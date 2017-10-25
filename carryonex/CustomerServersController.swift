//
//  CustomerServersController.swift
//  carryonex
//
//  Created by Xin Zou on 10/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class CustomerServersController: UIViewController {
    
    var dataSource: [ConfigSection]?
    
    //Zian - See if backend supports emoji.
    //var headers: [String] = ["猜你想问🔑","订单类🛎","支付类💳","软件问题📲","投诉问题⚠️"]
    
    //These should go to backend or we should map them based on whichever item we displaying
    let headerIcons: [UIImage] = [#imageLiteral(resourceName: "CarryonExIcon-29"), #imageLiteral(resourceName: "carryonex_sheet"), #imageLiteral(resourceName: "carryonex_wallet"), #imageLiteral(resourceName: "carryonex_setting"), #imageLiteral(resourceName: "carryonex_customerSev"), #imageLiteral(resourceName: "CarryonExIcon-29"), #imageLiteral(resourceName: "carryonex_sheet"), #imageLiteral(resourceName: "carryonex_wallet"), #imageLiteral(resourceName: "carryonex_setting"), #imageLiteral(resourceName: "carryonex_customerSev") ] // in case we need more sections, title from DB, icon is local;
    
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
        
        //If config not found, do nothing
        guard let config = ApiServers.shared.config else { return }
        
        //Setup the datasource
        dataSource = [config.faq, config.order, config.payment, config.softwareIssue, config.report]
        
        setupTableView()
        setupBottomButton()
    }
    
    private func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: customerServersCellId)
        tableView.register(FooterInfoCell.self, forCellReuseIdentifier: footerInfoCellId)
        tableView.backgroundColor = pickerColorLightGray
        
        view.addSubview(tableView)
        tableView.addConstraints(left: view.leftAnchor,
                                 top: topLayoutGuide.bottomAnchor,
                                 right: view.rightAnchor,
                                 bottom: view.bottomAnchor,
                                 leftConstent: 0,
                                 topConstent: 0,
                                 rightConstent: 0,
                                 bottomConstent: 40,
                                 width: 0,
                                 height: 0)
    }
    
    private func setupBottomButton(){
        view.addSubview(onlineCustomerServersButton)
        onlineCustomerServersButton.addConstraints(left: view.leftAnchor,
                                                   top: tableView.bottomAnchor,
                                                   right: view.rightAnchor,
                                                   bottom: view.bottomAnchor,
                                                   leftConstent: 0,
                                                   topConstent: 0,
                                                   rightConstent: 0,
                                                   bottomConstent: 0,
                                                   width: 0,
                                                   height: 0)
    }
}


extension CustomerServersController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let configSections = dataSource else { return 0 }
        return configSections.count + 1     //Add footer session
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let configSections = dataSource else { return 0 }
        if section == (configSections.count) { return 1 }   //Only 1 item in footer session
        let configUrlItems = configSections[section].urlItems
        return configUrlItems.count
    }
    
}


extension CustomerServersController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == titles.count - 1, indexPath.row == titles[indexPath.section].count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: footerInfoCellId, for: indexPath) 
            return cell
            
        } else {
            let configUrlItems = configSections[indexPath.section].urlItems
            let urlItem = configUrlItems[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: customerServersCellId, for: indexPath)
            cell.textLabel?.text = urlItem.title
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let configSections = dataSource else { return }
        
        if indexPath.section == configSections.count { return } //Footer
        
        let configUrlItems = configSections[indexPath.section].urlItems
        let urlItem = configUrlItems[indexPath.row]
        
        let webCtl = WebController()
        webCtl.url = URL(string: urlItem.url)
        webCtl.title = urlItem.title
        navigationController?.pushViewController(webCtl, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let configSections = dataSource else { return 0 }
        if indexPath.section == configSections.count { return 80 }  //footer section
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let configSections = dataSource else { return nil }
        let confSection = configSections[section]
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 36))
        v.backgroundColor = pickerColorLightGray
        
        let iconV = UIImageView(image: headerIcons[section])
        iconV.contentMode = .scaleAspectFit
        let titleV = UILabel()
        titleV.text = confSection.title
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
        guard let configSections = dataSource else { return 0 }
        if configSections.count == section { return 0 }  //footer section
        return 36
    }
}
