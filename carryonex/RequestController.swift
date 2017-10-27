//
//  RequestController.swift
//  carryonex
//
//  Created by Xin Zou on 8/20/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class RequestController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate {
    
    var costByItem: Float32 = 0.0
    
    var transparentView : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .clear
        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
        return v
    }()
    
    var activityIndicator: UIActivityIndicatorCustomizeView! // UIActivityIndicatorView!

    let labelW : CGFloat = 90
    
    var request : Request!
    
    // for picker range:
    let maxLen : Int = 30 // inch
    let maxWidth:Int = 20
    let maxHigh: Int = 10
    var volumLen: [Int] = [], volumWidth: [Int] = [], volumHigh: [Int] = []
    
    let imageCompress: CGFloat = 0.1
    var imageUploadingSet: Set<String> = []
    var imageUploadSequence: [String : URL] = [:] // imageName(tripId) : url

    let expectDeliveryTimes:[String] = ["三天内送达", "一周内送达", "二周内送达"]

    let labelNames = [ "发件地址:", "收货地址:", "货物总体积:", "货物总重量:", "货物清晰照:", "运货费用:"]
    let placeholders = ["请输入承运人的行程游箱号", "请输入发件地址", "请选择货物送达位置", "请选择包裹的尺寸(inch)", "请填写包裹总重量(磅)"]

    let basicCellId = "basicCellId"         // 1 - 3
    let weightCellId = "weightCellId"       // 4
    let sendingTimeCellId = "sendingTimeCellId" // 5
    let expectDeliveryTimeCellId = "expectDeliveryTimeCellId" // 6
    let imageCellId = "imageCellId"
    let costCellId = "costCellId"           // 7
    
    var cell01Departure:    RequestBaseCell?
    var cell02Destination:  RequestBaseCell?
    var cell03Volum:        RequestBaseCell?
    var cell04Weight :      WeightCell?
    var cell08Image:        ImageCell?
    var cell07Cost :        CostCell?
    
    
    /// for paymentButton.isEnable condictions
    var is01DepartureSet = false, is02DestinationSet = false, is03VolumSet = false
    var is04WeightSet = false, is05SendingTimeSet = false, is06ExpectDeliverySet = false
    
    
    var volumPickerMenu : UIPickerMenuView?
    var expectDeliveryTimePickerMenu : UIPickerMenuView?
    var volumePickerHeighConstraint: NSLayoutConstraint?
    
    
    lazy var volumePicker : UIPickerView = {
        let p = UIPickerView()
        p.dataSource = self
        p.delegate = self
        p.isHidden = false
        p.tag = 3 // the id of this picker
        return p
    }()
    
    lazy var volumeMenuOKButton : UIButton = {
        let b = UIButton()
        let attributes:[String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16),
            NSForegroundColorAttributeName: textThemeColor]
        let attribStr = NSAttributedString(string: "确定", attributes: attributes)
        b.setAttributedTitle(attribStr, for: .normal)
        b.addTarget(self, action: #selector(volumeMenuOKButtonTapped), for: .touchUpInside)
        return b
    }()
    lazy var expectDeliveryTimeMenuOKButton: UIButton = {
        let b = UIButton()
        let attributes:[String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16),
            NSForegroundColorAttributeName: textThemeColor]
        let attribStr = NSAttributedString(string: "确定", attributes: attributes)
        b.setAttributedTitle(attribStr, for: .normal)
        b.addTarget(self, action: #selector(expectDeliveryTimeMenuOKButtonTapped), for: .touchUpInside)
        return b
    }()
    lazy var volumePickerCancelButton: UIButton = {
        let b = UIButton()
        let attributes:[String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16),
            NSForegroundColorAttributeName: UIColor.gray]
        let attribStr = NSAttributedString(string: "取消", attributes: attributes)
        b.setAttributedTitle(attribStr, for: .normal)
        b.addTarget(self, action: #selector(pickersCancelButtonTapped), for: .touchUpInside)
        b.backgroundColor = .clear
        return b
    }()
    lazy var expectDeliveryPickerCancelButton: UIButton = {
        let b = UIButton()
        let attributes:[String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16),
            NSForegroundColorAttributeName: UIColor.gray]
        let attribStr = NSAttributedString(string: "取消", attributes: attributes)
        b.setAttributedTitle(attribStr, for: .normal)
        b.addTarget(self, action: #selector(pickersCancelButtonTapped), for: .touchUpInside)
        b.backgroundColor = .clear
        return b
    }()
    
    var blurEffect : UIBlurEffect!
    
    let pickerViewTitleLabel : UILabel = {
        let b = UILabel()
        b.textAlignment = .center
        b.font = UIFont.boldSystemFont(ofSize: 18)
        return b
    }()
    var pickerViewSubtitleStackView : UIStackView!
    
    lazy var sendingTimeButton: UIButton = {
        let b = UIButton()
        let attributes: [String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16),
            NSForegroundColorAttributeName: UIColor.lightGray ]
        let attTitleStr = NSAttributedString(string: "选择取货时间", attributes: attributes)
        b.setAttributedTitle(attTitleStr, for: .normal)
        b.contentHorizontalAlignment = .right
        b.addTarget(self, action: #selector(sendingTimeButtonTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var expectDeliveryTimeButton: UIButton = {
        let b = UIButton()
        let attributes: [String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16),
            NSForegroundColorAttributeName: UIColor.lightGray ]
        let attTitleStr = NSAttributedString(string: "选择期望送达时间", attributes: attributes)
        b.setAttributedTitle(attTitleStr, for: .normal)
        b.contentHorizontalAlignment = .right
        b.addTarget(self, action: #selector(expectDeliveryTimeButtonTapped), for: .touchUpInside)
        return b
    }()
    
    var expectDeliveryTimePickerHeighConstraint: NSLayoutConstraint?
    
    lazy var expectDeliveryTimePicker : UIPickerView = {
        let p = UIPickerView()
        p.dataSource = self
        p.delegate = self
        p.isHidden = false
        p.tag = 6 // the id of this picker
        return p
    }()
    
    let costSumLabel: UILabel = {
        let l = UILabel()
        l.textColor = textThemeColor
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.textAlignment = .right
        l.text = "0元"
        return l
    }()
    
    lazy var paymentButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .lightGray
        //b.isEnabled = false
        b.setTitle("支付方式", for: .normal)
        b.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
        return b
    }()

    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //removeAllImageFromLocal() // Do NOT remove it at here! will lost image data when new page shows!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setUpTransparentView()
        
        setupVolumLenWidthHighValues()
        
        setupNavigationBar()
        
        setupCollectionView()
        
        setupPaymentButton()
        
        setupPickers()
        
        setupActivityIndicator()
        
    }
    
    private func setUpTransparentView(){
        view.addSubview(transparentView)
        transparentView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    private func setupNavigationBar(){
        title = "发货请求"
        
        let rightItemButton = UIBarButtonItem(title: "支付方式", style: .plain, target: self, action: #selector(paymentButtonTapped))
        navigationItem.rightBarButtonItem = rightItemButton
    }
    
    private func setupCollectionView(){
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = false
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.register(RequestBaseCell.self, forCellWithReuseIdentifier: basicCellId)
        collectionView?.register(WeightCell.self, forCellWithReuseIdentifier: weightCellId)
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: imageCellId)
        collectionView?.register(CostCell.self, forCellWithReuseIdentifier: costCellId)
        
        let w : CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 10 : 36
        collectionView?.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: w, topConstent: 0, rightConstent: w, bottomConstent: 40, width: 0, height: 0)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellId : String = basicCellId
        
        switch indexPath.item {
        case 4 :
            cellId = weightCellId
        case 5 :
            cellId = imageCellId
        case 6 :
            cellId = costCellId
        default:
            cellId = basicCellId
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RequestBaseCell
        cell.requestController = self
        cell.textField.delegate = self
        cell.textField.tag = indexPath.item
        cell.titleLabel.text = labelNames[indexPath.item]
        
        switch indexPath.item {

        case 0 :
            cell01Departure = cell
            cell01Departure?.textField.placeholder = placeholders[indexPath.item]

        case 1 :
            cell02Destination = cell
            cell02Destination?.textField.placeholder = placeholders[indexPath.item]
            
        case 2 :
            cell03Volum = cell
            cell03Volum?.textField.placeholder = placeholders[indexPath.item]
        case 3 :
            if let cell = cell as? WeightCell {
                cell04Weight = cell
                cell04Weight?.textField.placeholder = placeholders[indexPath.item]
            }
        case 4 :
            if let cell = cell as? ImageCell {
                cell08Image = cell
            }
        case 5 :
            if let cell = cell as? CostCell {
                cell07Cost = cell
                cell07Cost?.addExtraContentToRight(costSumLabel)
            }
        default:
            cell.textField.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = collectionView.bounds.width
        let h : CGFloat = 50
        
        switch indexPath.item {
        case 0:
            return CGSize(width: w, height: 96)
        case 5:
            return CGSize(width: w, height: UIDevice.current.userInterfaceIdiom == .phone ? 180 : 260)
        default:
            return CGSize(width: w, height: h)
        }
    }
    

    
    private func setupPickers(){

        setupVolumLenWidthHighValues()
        
        volumPickerMenu = UIPickerMenuView(frame: .zero)
        volumPickerMenu?.setupMenuWith(hostView: self.view, targetPickerView: volumePicker, leftBtn: volumePickerCancelButton, rightBtn: volumeMenuOKButton)
        
        expectDeliveryTimePickerMenu = UIPickerMenuView(frame: .zero)
        expectDeliveryTimePickerMenu?.setupMenuWith(hostView: self.view, targetPickerView: expectDeliveryTimePicker, leftBtn: expectDeliveryPickerCancelButton, rightBtn: expectDeliveryTimeMenuOKButton)
    }
    
    
    private func subtitleCellLabel(_ str: String) -> UILabel {
        let l = UILabel()
        l.text = str
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 18)
        return l
    }
    
    
    private func setupPaymentButton(){
        view.addSubview(paymentButton)
        paymentButton.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 40)
    }
    
    
    
    private func setupActivityIndicator(){
        activityIndicator = UIActivityIndicatorCustomizeView() // UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.center = view.center
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.addSubview(activityIndicator)
    }
    

    
    
    
}



