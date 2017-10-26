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
    
    // row in collectionView: 0:youxiang 1:depa, 2:destnat, 3:volum,   4:weight,  5:sendingTi, 6:expectDeliv, 7:cost,
    //let labelNames = ["游箱号(选填):", "取货地址:", "收货地址:", "货物总体积:", "货物总重量:", "取货时间:", "期望到达时间:", "运货费用:"]
    // row in collectionView: 0:youxiang 1:depa, 2:destnat,  3:volum,   4:weight,   5:cost
    let labelNames = ["游箱号(选填):", "发件地址:", "收货地址:", "货物总体积:", "货物总重量:", "货物清晰照:", "运货费用:"]
    let placeholders = ["请输入承运人的行程游箱号", "请输入发件地址", "请选择货物送达位置", "请选择包裹的尺寸(inch)", "请填写包裹总重量(磅)"]

    let basicCellId = "basicCellId"         // 1 - 3
    let youxiangCellId = "youxiangCellId"   // 0
    let weightCellId = "weightCellId"       // 4
    let sendingTimeCellId = "sendingTimeCellId" // 5
    let expectDeliveryTimeCellId = "expectDeliveryTimeCellId" // 6
    let imageCellId = "imageCellId"
    let costCellId = "costCellId"           // 7
    
    var cell00Youxiang :    YouxiangCell?
    var cell01Departure:    RequestBaseCell?
    var cell02Destination:  RequestBaseCell?
    var cell03Volum:        RequestBaseCell?
    var cell04Weight :      WeightCell?
    //var cell05SendingTime:  SendingTimeCell?
    //var cell06ExpectDelivery:ExpectDeliveryTimeCell?
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
    
//    lazy var blurView : UIVisualEffectView = {
//        let v = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light ))
//        v.isUserInteractionEnabled = true
//        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickerViewAnimateToHide)))
//        return v
//    }()
    
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
//        b.backgroundColor = .green
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
//        b.backgroundColor = .green
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
//        l.backgroundColor = .yellow
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
        
        collectionView?.register(YouxiangCell.self, forCellWithReuseIdentifier: youxiangCellId)
        collectionView?.register(RequestBaseCell.self, forCellWithReuseIdentifier: basicCellId)
        collectionView?.register(WeightCell.self, forCellWithReuseIdentifier: weightCellId)
        //collectionView?.register(SendingTimeCell.self, forCellWithReuseIdentifier: sendingTimeCellId)
        //collectionView?.register(ExpectDeliveryTimeCell.self, forCellWithReuseIdentifier: expectDeliveryTimeCellId)
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: imageCellId)
        collectionView?.register(CostCell.self, forCellWithReuseIdentifier: costCellId)
        
//        view.addSubview(collectionView)
        let w : CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 10 : 36
        collectionView?.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: w, topConstent: 0, rightConstent: w, bottomConstent: 40, width: 0, height: 0)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellId : String = basicCellId
        
        switch indexPath.item {
        case 0 :
            cellId = youxiangCellId
        case 4 :
            cellId = weightCellId
        //case 5 :
        //    cellId = sendingTimeCellId
        //case 6 :
        //    cellId = expectDeliveryTimeCellId
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
            if let cell = cell as? YouxiangCell {
                cell00Youxiang = cell
                cell00Youxiang?.textField.placeholder = placeholders[indexPath.item]
            }
        case 1 :
            cell01Departure = cell
            cell01Departure?.textField.placeholder = placeholders[indexPath.item]
//            cell01Departure?.titleLabelWidthConstraint?.isActive = false // close it before change
//            cell01Departure?.titleLabelWidthConstraint = cell01Departure?.titleLabel.widthAnchor.constraint(equalToConstant: 60)
//            cell01Departure?.titleLabelWidthConstraint?.isActive = true
        case 2 :
            cell02Destination = cell
            cell02Destination?.textField.placeholder = placeholders[indexPath.item]
//            cell02Destination?.titleLabelWidthConstraint?.isActive = false // close it before change
//            cell02Destination?.titleLabelWidthConstraint = cell02Destination?.titleLabel.widthAnchor.constraint(equalToConstant: 60)
//            cell02Destination?.titleLabelWidthConstraint?.isActive = true
        case 3 :
            cell03Volum = cell
            cell03Volum?.textField.placeholder = placeholders[indexPath.item]
        case 4 :
            if let cell = cell as? WeightCell {
                cell04Weight = cell
                cell04Weight?.textField.placeholder = placeholders[indexPath.item]
            }
//        case 5 :
//            if let cell = cell as? SendingTimeCell {
//                cell05SendingTime = cell
//                cell05SendingTime?.textField.text = "10月4日12:00-22:00"
//                cell05SendingTime?.addExtraContentToRight(sendingTimeButton)
//            }
//        case 6 :
//            if let cell = cell as? ExpectDeliveryTimeCell {
//                cell06ExpectDelivery = cell
//                cell06ExpectDelivery?.addExtraContentToRight(expectDeliveryTimeButton)
//            }
        case 5 :
            if let cell = cell as? ImageCell {
                cell08Image = cell
            }
        case 6 :
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
    
    
    
    
//    private func setupBlurView(_ margin: CGFloat){
//        guard let window = UIApplication.shared.keyWindow else { return }
//        blurEffect = blurView.effect as! UIBlurEffect
//        window.addSubview(blurView)
//        blurView.frame = window.bounds
//        blurView.isHidden = true
//        
//        addBlurViewSubtitleLabel(margin) // 2 titles setup order should NOT be change
//        addBlurViewTitleLabel()
//    }
//    
    // add subtitleLabel
//    private func addBlurViewSubtitleLabel(_ margin: CGFloat){
//        let titleL = subtitleCellLabel("长")
//        let titleW = subtitleCellLabel("宽")
//        let titleH = subtitleCellLabel("高")
//        pickerViewSubtitleStackView = UIStackView(arrangedSubviews: [titleL, titleW, titleH])
//        pickerViewSubtitleStackView.axis = .horizontal
//        pickerViewSubtitleStackView.distribution = .fillEqually
//        
//        blurView.addSubview(pickerViewSubtitleStackView)
//        pickerViewSubtitleStackView.addConstraints(left: blurView.leftAnchor, top: nil, right: blurView.rightAnchor, bottom: nil, leftConstent: margin, topConstent: 0, rightConstent: margin, bottomConstent: 0, width: 0, height: 20)
//        let pickerHeigh = UIScreen.main.bounds.height / 3.0
//        pickerViewSubtitleStackView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor, constant: -(pickerHeigh / 2)).isActive = true
//    }
    // add titleLabel
//    private func addBlurViewTitleLabel(){
//        blurView.addSubview(pickerViewTitleLabel)
//        pickerViewTitleLabel.addConstraints(left: blurView.leftAnchor, top: nil, right: blurView.rightAnchor, bottom: pickerViewSubtitleStackView.topAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 20, width: 0, height: 30)
//    }
    
    private func subtitleCellLabel(_ str: String) -> UILabel {
        let l = UILabel()
        l.text = str
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 18)
        return l
    }
    
//    private func setupVolumePicker(_ margin: CGFloat){
//        blurView.addSubview(volumePicker)
//        volumePicker.addConstraints(left: blurView.leftAnchor, top: nil, right: blurView.rightAnchor, bottom: nil, leftConstent: margin, topConstent: 0, rightConstent: margin, bottomConstent: 0, width: 0, height: 0)
//        volumePicker.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
//        volumePickerHeighConstraint = volumePicker.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3.0)
//        volumePickerHeighConstraint?.isActive = true
//        volumePicker.isHidden = true
//    }
//    
//    private func setupExpectDeliveryTimePicker(_ margin: CGFloat){
//        blurView.addSubview(expectDeliveryTimePicker)
//        expectDeliveryTimePicker.addConstraints(left: blurView.leftAnchor, top: nil, right: blurView.rightAnchor, bottom: nil, leftConstent: margin, topConstent: 0, rightConstent: margin, bottomConstent: 0, width: 0, height: 0)
//        expectDeliveryTimePicker.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
//        expectDeliveryTimePickerHeighConstraint = expectDeliveryTimePicker.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4.0)
//        expectDeliveryTimePickerHeighConstraint?.isActive = true
//        expectDeliveryTimePicker.isHidden = true
//    }
    
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



