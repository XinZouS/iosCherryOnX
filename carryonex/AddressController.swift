//
//  AddressController.swift
//  carryonex
//
//  Created by Xin Zou on 8/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class AddressController: UIViewController, UITableViewDelegate,UICollectionViewDelegateFlowLayout, UITableViewDataSource,UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate{
    
    let maxLen : Int = 30 // inch
    let maxWidth:Int = 20
    let maxHigh: Int = 10
    
    let address = Address()
    
    var areaPickerMenu : UIPickerMenuView?
    //所以地址数据集合
    var addressArray = [[String: AnyObject]]()
    
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择市区的索引
    var areaIndex = 0
    
    var indexOfCountry = 0
    
    lazy var pickerView : UIPickerView = {
        let p = UIPickerView()
        p.dataSource = self
        p.delegate = self
        p.isHidden = false
        p.tag = 3 // the id of this picker
        return p
    }()
    
    lazy var areaMenuOKButton : UIButton = {
        let b = UIButton()
        let attributes:[String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16),
            NSForegroundColorAttributeName: textThemeColor]
        let attribStr = NSAttributedString(string: "确定", attributes: attributes)
        b.setAttributedTitle(attribStr, for: .normal)
        b.addTarget(self, action: #selector(areaMenuOKButtonTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var areaPickerCancelButton: UIButton = {
        let b = UIButton()
        let attributes:[String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16),
            NSForegroundColorAttributeName: UIColor.gray]
        let attribStr = NSAttributedString(string: "取消", attributes: attributes)
        b.setAttributedTitle(attribStr, for: .normal)
        b.addTarget(self, action: #selector(areaMenuCancelButtonTapped), for: .touchUpInside)
        b.backgroundColor = .clear
        return b
    }()
    
    let pickerViewTitleLabel : UILabel = {
        let b = UILabel()
        b.textAlignment = .center
        b.font = UIFont.boldSystemFont(ofSize: 18)
        return b
    }()
    
    var transparentView : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .clear
        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
        return v
    }()
    
    var request: Request?
    var trip   : Trip?
    var requestControler = RequestController()
    

    var requestCtl  : RequestController? {
        didSet{
            request = requestCtl?.request
        }
    }
    var postTripCtl : PostTripController? {
        didSet{
            trip = postTripCtl?.trip
        }
    }
    
    let sideMargin: CGFloat = 30

    var isStartAddress: Bool!
    var isChinese: Bool = true {
        didSet{
            changeUIforCountry()
        }
    }
    
     
    let labelTitles:[String] = ["所在地区", "省份（直辖市）:", "市（区）", "详细地址:", "邮政编码:", "收件人姓名:", "收件人联系方式:", "okButton"]
    
    // tableView reusableCellId
    let addressBaseCellId = "addressBaseCellId" // line 0
    let provinceAndCityCellId = "provinceAndCityCellId" //1,2
    let addressDetailCellId = "addressDetailCellId"   // 3
    let zipcodeAndNameCellId = "zipcodeAndNameCellId" // 4,5
    let recipientPhoneCellId = "recipientPhoneCellId" // 6
    let buttonCellId = "buttonCellId"   // 7
    
    // idString for cell reacts to button and textField
    let countryCellIdstring     = "countryCellIdstring"
    let provinceCellIdString    = "provinceCellIdString"
    let cityCellIdString        = "cityCellIdString"
    let addresDetailCellIdString = "addresDetailCellIdString"
    let zipcodeCellIdString     = "zipcodeCellIdString"
    let recipitenNameCellIdString = "recipitenNameCellIdString"
    let recipientPhoneCellIdString = "recipientPhoneCellIdString"
    let buttonCellIdString      = "buttonCellIdString"
    
    var countryCell : AddressBaseCell!
    var provinceCell: ProvinceAndCityCell!
    var cityCell :    ProvinceAndCityCell!
    var addressDetailCell : AddressDetailCell!
    var zipcodeCell: ZipcodeAndNameCell!
    var recipientNameCell: ZipcodeAndNameCell!
    var recipientPhoneCell : RecipientPhoneCell! // for changing phone zone code
    var buttonCell : ButtonCell!
    
    
    lazy var okButton : UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        b.backgroundColor = buttonThemeColor
        b.setTitle("完成", for: .normal)
        return b
    }()
    
    
    let zipcodeLabel: UILabel = {
        let b = UILabel()
        b.text = ""
        b.textAlignment = .left
        b.textColor = .black
        b.font = UIFont.systemFont(ofSize: 16)
        return b
    }()
    
    let recipientNameLabel: UILabel = {
        let b = UILabel()
        b.text = ""
        b.textAlignment = .left
        b.textColor = .black
        b.font = UIFont.systemFont(ofSize: 16)
        return b
    }()
    
    
    
    var tableViewBottomConstraint: NSLayoutConstraint!
    
    lazy var tableView: UITableView = {
        let v = UITableView()
        v.delegate = self
        v.dataSource = self
        v.backgroundColor = pickerColorLightGray
        return v
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = pickerColorLightGray
        
        setupNavigationBar()
        
        setupTableView()
        
        setupOkButton()
        
        setUpTransparentView()
        
        setUpPicker()
        
        selectCountry()
        
    }
    
    func setUpPicker(){
        areaPickerMenu = UIPickerMenuView(frame: .zero)
        areaPickerMenu?.setupMenuWith(hostView: self.view, targetPickerView: pickerView, leftBtn: areaPickerCancelButton, rightBtn: areaMenuOKButton)
        view.addSubview(areaPickerMenu!)
    }
    
    //设置选择框的列数为3列,继承于UIPickerViewDataSource协议
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch indexOfCountry {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    //设置选择框的行数，继承于UIPickerViewDataSource协议
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        switch indexOfCountry {
        case 0:
            if component == 0 {
                return self.addressArray.count
            } else if component == 1 {
                let province = self.addressArray[provinceIndex]
                return province["cities"]!.count
            } else {
                let province = self.addressArray[provinceIndex]
                if let city = (province["cities"] as! NSArray)[cityIndex]
                    as? [String: AnyObject] {
                    return city["areas"]!.count
                } else {
                    return 0
                }
            }
        case 1:
            if component == 0 {
                return self.addressArray.count
            } else if component == 1 {
                let province = self.addressArray[provinceIndex]
                return province["cities"]!.count
            }else {
                return 0
            }
        default:
            return 0
        }
    }
    
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if indexOfCountry == 0 {
            if component == 0 {
                return self.addressArray[row]["state"] as? String
            }else if component == 1 {
                let province = self.addressArray[provinceIndex]
                let city = (province["cities"] as! NSArray)[row]
                    as! [String: AnyObject]
                return city["city"] as? String
            }else {
                let province = self.addressArray[provinceIndex]
                let city = (province["cities"] as! NSArray)[cityIndex]
                    as! [String: AnyObject]
                return (city["areas"] as! NSArray)[row] as? String
            }
        }
        if component == 0 {
            return self.addressArray[row]["state"] as? String
        } else {
            let province = self.addressArray[provinceIndex]
            let city = (province["cities"] as! NSArray)[row]
                as! [String: AnyObject]
            return city["city"] as? String
        }
    }
    
    //选中项改变事件（将在滑动停止后触发）
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        //根据列、行索引判断需要改变数据的区域
        if(indexOfCountry == 0){
            switch (component) {
            case 0:
                provinceIndex = row;
                cityIndex = 0;
                pickerView.reloadComponent(1);
                pickerView.reloadComponent(2);
                pickerView.selectRow(0, inComponent: 1, animated: false)
                pickerView.selectRow(0, inComponent: 2, animated: false)
            case 1:
                cityIndex = row;
                pickerView.reloadComponent(2);
                pickerView.selectRow(0, inComponent: 2, animated: false)
            case 2:
                areaIndex = row;
            default:
                break;
            }
        } else {
            switch (component) {
            case 0:
                provinceIndex = row;
                cityIndex = 0;
                pickerView.reloadComponent(1);
                pickerView.selectRow(0, inComponent: 1, animated: false)
            case 1:
                cityIndex = row;
            default:
                break;
            }
        }
    }
    
    private func setUpTransparentView(){
        view.addSubview(transparentView)
        transparentView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    private func setupNavigationBar(){
        title = "收货地址"
        
        let leftItemButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = leftItemButton

        let rightItemButton = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(okButtonTapped))
        navigationItem.rightBarButtonItem = rightItemButton
    }
    
    private func setupTableView(){
        
        tableView.register(AddressBaseCell.self, forCellReuseIdentifier: addressBaseCellId)
        tableView.register(ProvinceAndCityCell.self, forCellReuseIdentifier: provinceAndCityCellId)
        tableView.register(AddressDetailCell.self, forCellReuseIdentifier: addressDetailCellId)
        tableView.register(ZipcodeAndNameCell.self, forCellReuseIdentifier: zipcodeAndNameCellId)
        tableView.register(RecipientPhoneCell.self, forCellReuseIdentifier: recipientPhoneCellId)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: buttonCellId)
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 15, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        tableViewBottomConstraint.isActive = true
    }
    
    private func setupOkButton(){
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        view.addSubview(okButton)
        okButton.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 40)
    }
    
    
    /// - MARK: tableView delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelTitles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell!
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: addressBaseCellId, for: indexPath) as! AddressBaseCell
            countryCell = cell as! AddressBaseCell
            countryCell.addressCtl = self
            countryCell.idString = countryCellIdstring
            countryCell.titleLabel.text = labelTitles[indexPath.row]
            countryCell.selectedLabel.text = Country.China.rawValue
        case 1,2:
            cell = tableView.dequeueReusableCell(withIdentifier: provinceAndCityCellId, for:indexPath) as! ProvinceAndCityCell
            if indexPath.row == 1 {
                provinceCell = cell as! ProvinceAndCityCell
                provinceCell.addressCtl = self
                provinceCell.idString = provinceCellIdString
                provinceCell.titleLabel.text = labelTitles[indexPath.row]
                provinceCell.textField.tag = 1
                provinceCell.textField.placeholder = "选择省份（直辖市）"
            }else{
                cityCell = cell as! ProvinceAndCityCell
                cityCell.addressCtl = self
                cityCell.idString = cityCellIdString
                cityCell.titleLabel.text = labelTitles[indexPath.row]
                cityCell.textField.tag = 2
                cityCell.textField.placeholder = "选择市（区）"
            }
            
            
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: addressDetailCellId, for: indexPath) as! AddressDetailCell
            addressDetailCell =  cell as! AddressDetailCell
            addressDetailCell.addressCtl = self
            addressDetailCell.idString = addresDetailCellIdString
            addressDetailCell.titleLabel.text = labelTitles[indexPath.row]
        case 4,5:
            cell = tableView.dequeueReusableCell(withIdentifier: zipcodeAndNameCellId, for: indexPath) as! ZipcodeAndNameCell
            if indexPath.row == 4 {
                zipcodeCell = cell as! ZipcodeAndNameCell
                zipcodeCell.addressCtl = self
                zipcodeCell.idString = zipcodeCellIdString
                zipcodeCell.titleLabel.text = labelTitles[indexPath.row]
                zipcodeCell.textField.placeholder = isChinese ? "请输入六位邮政编码" : "请输入五位邮政编码"
            }else
            if indexPath.row == 5 {
                recipientNameCell = cell as! ZipcodeAndNameCell
                recipientNameCell.addressCtl = self
                recipientNameCell.idString = recipitenNameCellIdString
                recipientNameCell.titleLabel.text = labelTitles[indexPath.row]
                recipientNameCell.textField.placeholder = "请输入收件人的真实姓名"
            }
        case 6:
            cell = tableView.dequeueReusableCell(withIdentifier: recipientPhoneCellId, for: indexPath) as! RecipientPhoneCell
            recipientPhoneCell = cell as! RecipientPhoneCell
            recipientPhoneCell.addressCtl = self
            recipientPhoneCell.idString = recipientPhoneCellIdString
            recipientPhoneCell.countryCodeLabel.text = flagsTitle[0]
            recipientPhoneCell.titleLabel.text = labelTitles[indexPath.row]
            recipientPhoneCell.textField.placeholder = "收件人电话/手机"
        case 7:
            cell = tableView.dequeueReusableCell(withIdentifier: buttonCellId, for: indexPath) as! ButtonCell
            buttonCell = cell as! ButtonCell
            buttonCell.addressCtl = self
            buttonCell.idString = buttonCellIdString
            buttonCell.okButton.isHidden = UIDevice.current.userInterfaceIdiom == .pad
            buttonCell.okButton.isEnabled = UIDevice.current.userInterfaceIdiom == .phone
            
        default:
            cell = UITableViewCell()
        }
        
        cell.backgroundColor = pickerColorLightGray

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 1, 2:
            return 50
        case 3:
            return view.bounds.height < 670 ? 150 : 180
        case 4, 5, 6:
            return 80
        case 7: // 底部button位置适配不同手机高度, 我一个个写出来，不信搞不定你🤣
            guard UIDevice.current.userInterfaceIdiom == .phone else { return 30 } //set btn at bottom for pad
            
            if view.bounds.height > 667 { //  6+,6s+,7+: 736(90)
                return 90
            }else
            if view.bounds.height == 667 { // 6,6s,7: h=667(48),
                return 48
            }else{
                return 40 // 5: h=568(40),
            }
        default:
            return 30
        }
    }
    
    

    
}

