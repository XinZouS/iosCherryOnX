//
//  PostTripController.swift
//  carryonex
//
//  Created by Xin Zou on 8/28/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class PostTripController:UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
    var trip = Trip()
    var addressStarting : Address? // trip only contains addressId.
    var addressDestinat : Address?
    
    var dateFormatter : DateFormatter = {
        let f = DateFormatter()
        f.timeZone = TimeZone.current
        f.dateFormat = "yyyy年MM月dd日" // "MM-dd-yyyy" // TODO: for english date
        return f
    }()
//     row in collectionView: 0:transporation, 1:flightInfo, 
    let labelNames:     [String] = ["游箱类别", "出发地：", "目的地：", "出发时间："]
    let placeholders:   [String] = ["请选择出行方式", "请选择出发地", "请选择目的地", "请选择出发时间", "设置取货时间段"]
    let cellIds:        [String] = ["transportationCellId", "startAddressCellId", "endAddressCellId", "startTimeCellId", "pickUpTimeCellId"]
    
    let transportationCellId = "transportationCellId"
    let flightInfoCellId    = "flightInfoCellId" // currently not using this one;
    let startAddressCellId  = "startAddressCellId"
    let endAddressCellId    = "endAddressCellId"
    let startTimeCellId     = "startTimeCellId"
    let pickUpTimeCellId    = "pickUpTimeCellId"
    
    var transportationCell : PostBaseCell?
    var flightInfoCell     : PostBaseCell? // currently not using this one;
    var startAddressCell   : PostBaseCell?
    var endAddressCell     : PostBaseCell?
    var startTimeCell      : PostBaseCell?
    //var pickUpTimeCell     : PostBaseCell?
    
    var isTransportationSetted = false
    var isStartAddressSetted = false
    var isEndAddressSetted = false
    
    let basicTripCellId = "basicTripCellId"
    
    lazy var youxiangCategorySegment: UISegmentedControl = {
        let s = UISegmentedControl(items: ["后备箱", "行李箱"])
        //s.tintColor = .white
        s.tintColor = buttonThemeColor
        s.selectedSegmentIndex = 0
        s.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 16)], for: .normal)
        s.addTarget(self, action: #selector(changeYouxiangCategory), for: .valueChanged)
        return s
    }()
    

    lazy var okButton : UIButton = {
        let b = UIButton()
        b.setTitle("确认行程", for: .normal)
        b.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        b.backgroundColor = UIColor.lightGray
        b.tintColor = .black
        return b
    }()
    
    var activityIndicator: UIActivityIndicatorCustomizeView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupOkButton()
        setupCollectionView()
        setupActivityIndicatorView()
    }
    
    private func setupNavigationBar(){
        title = "出行"
        UINavigationBar.appearance().tintColor = buttonColorWhite
        navigationController?.navigationBar.tintColor = buttonColorWhite
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: buttonColorWhite]
        
        let righItemBtn = UIBarButtonItem(title: "确认", style: .plain, target: self, action: #selector(okButtonTapped))
        navigationItem.rightBarButtonItem = righItemBtn
    }
     
    private func setupOkButton(){
        view.addSubview(okButton)
        okButton.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 40)
    }
    
    private func setupCollectionView(){
        let sideMargin: CGFloat = (UIDevice.current.userInterfaceIdiom == .phone) ? 10 : 36
        self.collectionView?.register(PostBaseCell.self, forCellWithReuseIdentifier: basicTripCellId)
        self.collectionView?.backgroundColor = .white
//        self.collectionView?.contentInset = UIEdgeInsetsMake(10, sideMargin, 10, sideMargin) // top, left, btm, right
        collectionView?.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: okButton.topAnchor, leftConstent: sideMargin, topConstent: 10, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 0)
    }
    
    private func setupSegmentedControl(_ cell: PostBaseCell){
        cell.addSubview(youxiangCategorySegment)
        youxiangCategorySegment.addConstraints(left: cell.titleLabel.rightAnchor, top: nil, right: cell.rightAnchor, bottom: nil, leftConstent: 20, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        youxiangCategorySegment.centerYAnchor.constraint(equalTo: cell.infoLabel.centerYAnchor).isActive = true
    }
    
    private func setupActivityIndicatorView(){
        activityIndicator = UIActivityIndicatorCustomizeView() 
        activityIndicator.frame = CGRect(x:view.center.x-15,y:view.center.y-64,width:0,height:0)
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.addSubview(activityIndicator)
    }

    
    func changeYouxiangCategory(){
        switch youxiangCategorySegment.selectedSegmentIndex {
        case 0:
            trip.transportation = .trunk
        case 1:
            trip.transportation = .luggage
        default:
            trip.transportation = .trunk
        }
        print("selected transporation at: \(trip.transportation.rawValue)")
    }
    
    

    
    /// -MARK: collectionView Delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: basicTripCellId, for: indexPath) as! PostBaseCell
        cell.postTripController = self
        cell.titleLabel.text = labelNames[indexPath.item]
        cell.infoLabel.text = placeholders[indexPath.item]
        cell.idString = cellIds[indexPath.item]
        
        switch indexPath.item {
        case 0:
            transportationCell = cell
            cell.infoButton.isEnabled = false
            cell.infoButton.isHidden = true
            cell.infoLabel.isHidden = true
            setupSegmentedControl(transportationCell!)
        case 1:
            startAddressCell = cell
        case 2:
            endAddressCell = cell
        case 3:
            startTimeCell = cell
            startTimeCell?.infoLabel.text = self.dateFormatter.string(from: Date())
            startTimeCell?.infoLabel.textColor = .black
            trip.pickupDate = Date().timeIntervalSince1970 // today's Date as Double
//        case 4:
//            pickUpTimeCell = cell
        default:
            print("get undefined cell indexPath, item = ", indexPath.item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w : CGFloat = collectionView.bounds.width
        let h : CGFloat = 50
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}



