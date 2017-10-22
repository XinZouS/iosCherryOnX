//
//  CustomerServersController.swift
//  carryonex
//
//  Created by Xin Zou on 10/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class CustomerServersController: UIViewController {
    
    let titles: [[String]] = [
        ["服务区域", "特殊物品"],
        ["认证与个人资料", "订单无响应"],
        ["支付与账户", "运费到账时间"],
        ["在美国境外能用吗", "软件安全"],
        ["寄件人安全与控诉", "出行人安全与控诉", "责任追究", " "] // the last one empty is for "footer" info
    ]
    let headers: [String] = ["猜你想问","订单类","支付类","软件问题","投诉问题"]
    let headerIcons: [UIImage] = [#imageLiteral(resourceName: "CarryonExIcon-29"), #imageLiteral(resourceName: "carryonex_sheet"), #imageLiteral(resourceName: "carryonex_wallet"), #imageLiteral(resourceName: "carryonex_setting"), #imageLiteral(resourceName: "carryonex_customerSev") ]
    
    let urls: [[String]] = [
        ["https://www.carryonex.com/", "https://www.carryonex.com/"], // "服务区域", "特殊物品"
        ["\(userGuideWebHoster)/doc_verification", "https://www.carryonex.com/"], // "认证与个人资料", "订单无响应"
        ["\(userGuideWebHoster)/doc_payment", "\(userGuideWebHoster)/doc_payment_timing"], // "支付与账户", "运费到账时间"
        ["https://www.carryonex.com/", "https://www.carryonex.com/"], // "在美国境外能用吗", "软件安全"
        // "寄件人安全与控诉", "出行人安全与控诉", "责任追究", " "
        ["\(userGuideWebHoster)/doc_security_charge_requester", "\(userGuideWebHoster)/doc_security_charge_tripper", "https://www.carryonex.com/", " "]
    ]
    
    let customerServersCellId = "customerServersCellId"
    let footerInfoCellId = "footerInfoCellId"
    
    lazy var tableView : UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        return t
    }()
    
    
    lazy var onlineCustomerServersButton : UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(onlineCustomerServersButtonTapped), for: .touchUpInside)
        b.backgroundColor = buttonThemeColor
        let atts = [NSFontAttributeName: UIFont.systemFont(ofSize: 20),
                    NSForegroundColorAttributeName: UIColor.white]
        let attStr = NSAttributedString(string: "在线客服", attributes: atts)
        b.setAttributedTitle(attStr, for: .normal)
        return b
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "客服中心"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "CarryonEx_Back"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backBtn
        
        setupTableView()
        setupBottomButton()
    }
    
    private func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: customerServersCellId)
        tableView.register(FooterInfoCell.self, forCellReuseIdentifier: footerInfoCellId)
        tableView.backgroundColor = pickerColorLightGray
        
        view.addSubview(tableView)
        tableView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 40, width: 0, height: 0)
    }
    private func setupBottomButton(){
        view.addSubview(onlineCustomerServersButton)
        onlineCustomerServersButton.addConstraints(left: view.leftAnchor, top: tableView.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
}


extension CustomerServersController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == headers.count - 1, indexPath.row == titles[indexPath.section].count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: footerInfoCellId, for: indexPath) 
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: customerServersCellId, for: indexPath)
            cell.textLabel?.text = titles[indexPath.section][indexPath.row]
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == headers.count - 1, indexPath.row == titles[indexPath.section].count - 1 {
            return 80
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 36))
        v.backgroundColor = pickerColorLightGray
        
        let iconV = UIImageView(image: headerIcons[section])
        iconV.contentMode = .scaleAspectFit
        let titleV = UILabel()
        titleV.text = headers[section]
        titleV.font = UIFont.systemFont(ofSize: 16)
        titleV.textColor = .lightGray
        
        let sz : CGFloat = 30
        v.addSubview(iconV)
        iconV.addConstraints(left: v.leftAnchor, top: nil, right: nil, bottom: nil, leftConstent: 10, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: sz, height: sz)
        iconV.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        
        v.addSubview(titleV)
        titleV.addConstraints(left: iconV.rightAnchor, top: nil, right: v.rightAnchor, bottom: nil, leftConstent: 10, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 0, height: 20)
        titleV.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        
        return v
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    
    
}
