//
//  PaymentController.swift
//  carryonex
//
//  Created by Xin Zou on 8/27/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class PaymentController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextViewDelegate {
    
    var requestCtl : RequestController?
    
    var info = ""
    var request : Request?
    
    let pageMargin : CGFloat = 20
    
    let paymentCellId = "paymentCellId"
    
    let titleLabel : UILabel = {
        let b = UILabel()
        
        return b
    }()
    
    let contentLabel: UILabel = {
        let b = UILabel()
        b.text = "包含"
        return b
    }()
    
    let contentStackView : UIStackView = {
        let v = UIStackView()
        v.backgroundColor = .black
        v.alignment = UIStackViewAlignment.center
        v.distribution = .equalCentering
        v.axis = UILayoutConstraintAxis.vertical
        return v
    }()
    
    lazy var detailInformation : UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 16)
        return v
    }()
    
    let costLabel : UILabel = {
        let b = UILabel()
        b.backgroundColor = .white
        b.textAlignment = .right
        b.text = "运货费用："
        return b
    }()
    
    let underlineView : UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    let paymentLabel: UILabel = {
        let b = UILabel()
        b.textAlignment = .left
        b.text = "请选择支付方式:"
        b.font = UIFont.systemFont(ofSize: 12)
        return b
    }()
    
    var paymentSelected : Payment!
    let payments : [Payment] = [.applePay, .paypal, .creditCard, .wechatPay]
    let paymentIcons: [UIImage] = [#imageLiteral(resourceName: "CarryonEx_ApplePay"), #imageLiteral(resourceName: "CarryonEx_PayPal"), #imageLiteral(resourceName: "CarryonEx_CreditCard"), #imageLiteral(resourceName: "CarryonEx_WechatPay")]
    let paymentTitles: [String] = ["Apple Pay支付", "Paypal支付", "信用卡支付", "微信支付"]
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .white
        v.isUserInteractionEnabled = true
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    lazy var okButton : UIButton = {
        let b = UIButton()
        b.setTitle("确认付款", for: .normal)
        b.backgroundColor = buttonThemeColor
        b.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupTitleLabel()
        setupContentLabel()
        setupDetailInformation()
        setupContentStackView()
        setupCostLabelAndUnderlineView()
        setupPaymentLabel()
        setupOkButton()
        setupPaymentCollectionView()
        
    }
    
    private func setupNavigationBar(){
        title = "支付方式"
        
        let rightBtn = UIBarButtonItem(title: "确认付款", style: .plain, target: self, action: #selector(okButtonTapped))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    private func setupTitleLabel(){
        view.addSubview(titleLabel)
        titleLabel.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: pageMargin, topConstent: pageMargin, rightConstent: pageMargin, bottomConstent: 0, width: 0, height: 20)
        
        setupTitleAttributeText()
    }
    private func setupTitleAttributeText(){
        titleLabel.text = "您的订单XXXXXXXX（订单编号）将从XXX（出发地）到XXX（目的地）"
    }
    
    private func setupContentLabel(){ // "包含" label
        view.addSubview(contentLabel)
        contentLabel.addConstraints(left: view.leftAnchor, top: titleLabel.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: pageMargin, topConstent: 0, rightConstent: pageMargin, bottomConstent: 0, width: 0, height: 20)
    }
    
    private func setupDetailInformation(){
        view.addSubview(detailInformation)
        detailInformation.addConstraints(left: view.leftAnchor, top: contentLabel.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: pageMargin, topConstent: 0, rightConstent: pageMargin, bottomConstent: 0, width: 0, height: 40)
        detailInformation.text = request?.description
    }
    
    private func setupContentStackView(){
        view.addSubview(contentStackView)
        contentStackView.addConstraints(left: view.leftAnchor, top: detailInformation.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: pageMargin, topConstent: 0, rightConstent: pageMargin, bottomConstent: 0, width: 0, height: 40)
    }
    
    private func setupCostLabelAndUnderlineView(){
        view.addSubview(costLabel)
        costLabel.addConstraints(left: view.leftAnchor, top: contentStackView.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: pageMargin, topConstent: 0, rightConstent: pageMargin, bottomConstent: 0, width: 0, height: 30)
        
        view.addSubview(underlineView)
        underlineView.addConstraints(left: view.leftAnchor, top: costLabel.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
    }
    
    private func setupPaymentLabel(){
        view.addSubview(paymentLabel)
        paymentLabel.addConstraints(left: view.leftAnchor, top: underlineView.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: pageMargin, topConstent: 5, rightConstent: pageMargin, bottomConstent: 0, width: 0, height: 20)
    }
    
    private func setupOkButton(){
        view.addSubview(okButton)
        okButton.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 44, width: 0, height: 40)
    }
    
    private func setupPaymentCollectionView(){
        view.addSubview(collectionView)
        collectionView.addConstraints(left: view.leftAnchor, top: paymentLabel.bottomAnchor, right: view.rightAnchor, bottom: okButton.topAnchor, leftConstent: pageMargin, topConstent: 10, rightConstent: pageMargin, bottomConstent: 0, width: 0, height: 0)
        
        collectionView.register(PaymentCell.self, forCellWithReuseIdentifier: paymentCellId)
    }
    
    
    
    
    
}

