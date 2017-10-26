//
//  ConfirmBaseController.swift
//  carryonex
//
//  Created by Xin Zou on 8/28/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



/// -MARK: confirm page for both users


class ConfirmBaseController: UIViewController {
    
    /// One match MUST has both request and trip for [sender and carrier].
    var request : Request!
    var trip    : Trip!
    
    var isShowToSender : Bool!
    
    var cooperator : User!
    
    
    let backgroundBoxLine: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.borderColor = borderColorLightGray.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    let imageSize: CGFloat = 100
    let imageView: UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "CarryonEx_Profile_Orange")
        v.contentMode = .scaleAspectFit
        v.layer.cornerRadius = 50 // img size 100
        v.layer.masksToBounds = true
        return v
    }()
    
    let orderIdLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16)
        b.backgroundColor = .white
        b.text = "订单编号：6666666666"
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    
    let cooperatorNameLabel: UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16)
        b.backgroundColor = .white
        b.text = "接单人：xx"
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    
    let cooperatorPhoneLabel: UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16)
        b.backgroundColor = .white
        b.text = "联系电话：1234567890"
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    
    let deliveryTimeLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16)
        b.backgroundColor = .white
        b.text = "取货时间：2017年8月28日"
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    let deliveryLocationLabel:UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16)
        b.backgroundColor = .white
        b.text = "取货地点："
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    
    var deliveryLocationTxVwHeightConstraint : NSLayoutConstraint! // adjusting Height
    
    let deliveryLocationTextView: UITextView = {
        let v = UITextView()
        v.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16)
        v.backgroundColor = .clear
        v.textAlignment = .left
        v.text = "很长很长的地址应该用的是收货地的详细街道地址吧这样要至少2行才能显示出来啊吼吼！！"
        return v
    }()
    
    
    let expectingTimeOrCostLabel: UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16)
        b.backgroundColor = .white
        b.text = "预计到达时间：2017年08月30日"
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    
    lazy var finishButton : UIButton = {
        let b = UIButton()
        b.setTitle("完成订单", for: .normal)
        b.backgroundColor = buttonThemeColor
        b.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = pickerColorLightGray
        
        setupNavigationBar()
        setupBackgroundBox()
        setupImageView()
        setupInfoLabels()
        setupFinishButton()
        
    }
    
    private func setupNavigationBar(){
        title = "确认接单"
        let rightBtn = UIBarButtonItem(title: "订单记录", style: .plain, target: self, action: #selector(finishButtonTapped))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    private func setupBackgroundBox(){
        let sideMargin : CGFloat = 30
        view.addSubview(backgroundBoxLine)
        backgroundBoxLine.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: sideMargin, topConstent: 35, rightConstent: sideMargin, bottomConstent: 40, width: 0, height: 0)
    }
    
    private func setupImageView(){
        view.addSubview(imageView)
        imageView.addConstraints(left: nil, top: topLayoutGuide.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 70, rightConstent: 0, bottomConstent: 0, width: imageSize, height: imageSize)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupInfoLabels(){
        let leftMargin: CGFloat = UIScreen.main.bounds.width < 325 ? 50 : 80
        let rightMargin:CGFloat = 33
        let labelHeigh: CGFloat = 23
        let lineMargin: CGFloat = UIScreen.main.bounds.width < 325 ? 3 : 6
        
        let lf = view.leftAnchor
        let rt = view.rightAnchor
        
        view.addSubview(orderIdLabel)
        orderIdLabel.addConstraints(left: lf, top: imageView.bottomAnchor, right: rt, bottom: nil, leftConstent: leftMargin, topConstent: 30, rightConstent: rightMargin, bottomConstent: 0, width: 0, height: labelHeigh)
        
        view.addSubview(cooperatorNameLabel)
        cooperatorNameLabel.addConstraints(left: lf, top: orderIdLabel.bottomAnchor, right: rt, bottom: nil, leftConstent: leftMargin, topConstent: lineMargin, rightConstent: rightMargin, bottomConstent: 0, width: 0, height: labelHeigh)
        
        view.addSubview(cooperatorPhoneLabel)
        cooperatorPhoneLabel.addConstraints(left: lf, top: cooperatorNameLabel.bottomAnchor, right: rt, bottom: nil, leftConstent: leftMargin, topConstent: lineMargin, rightConstent: rightMargin, bottomConstent: 0, width: 0, height: labelHeigh)
        
        
        view.addSubview(deliveryTimeLabel)
        deliveryTimeLabel.addConstraints(left: lf, top: cooperatorPhoneLabel.bottomAnchor, right: rt, bottom: nil, leftConstent: leftMargin, topConstent: lineMargin, rightConstent: rightMargin, bottomConstent: 0, width: 0, height: labelHeigh)
        
        view.addSubview(deliveryLocationLabel)
        deliveryLocationLabel.addConstraints(left: lf, top: deliveryTimeLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: leftMargin, topConstent: lineMargin, rightConstent: 0, bottomConstent: 0, width: 80, height: labelHeigh)
        
        view.addSubview(deliveryLocationTextView)
        deliveryLocationTextView.addConstraints(left: deliveryLocationLabel.rightAnchor, top: deliveryTimeLabel.bottomAnchor, right: rt, bottom: nil, leftConstent: 2, topConstent: 0, rightConstent: leftMargin - 20, bottomConstent: 0, width: 0, height: 0)
        deliveryLocationTxVwHeightConstraint = deliveryLocationTextView.heightAnchor.constraint(equalToConstant: 75)
        deliveryLocationTxVwHeightConstraint.isActive = true
        
        view.addSubview(expectingTimeOrCostLabel)
        expectingTimeOrCostLabel.addConstraints(left: lf, top: deliveryLocationTextView.bottomAnchor, right: rt, bottom: nil, leftConstent: leftMargin, topConstent: lineMargin, rightConstent: rightMargin, bottomConstent: 0, width: 0, height: labelHeigh)
    }
    
    private func setupFinishButton(){
        let bottomMargin: CGFloat = UIScreen.main.bounds.width < 325 ? 55 : 80
        view.addSubview(finishButton)
        finishButton.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 80, topConstent: 0, rightConstent: 80, bottomConstent: bottomMargin, width: 0, height: 40)
    }
    
    
}



