//
//  UserSettingController.swift
//  carryonex
//
//  Created by Xin Zou on 10/15/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class UserSettingController: UIViewController {
    
    var userProfileView: UserProfileView?
    
    let titles: [[String]] = [["账号与安全", "语言"], ["用户指南", "给游箱评价", "法律条款与隐私政策", "关于游箱"]]
    
    let userSettingCellId = "userSettingCellId"
    
    lazy var tableView : UITableView = {
        let v = UITableView()
        v.delegate = self
        v.dataSource = self
        return v
    }()
    
    lazy var logoutButton : UIButton = {
        let b = UIButton()
        b.backgroundColor = buttonThemeColor
        b.tintColor = buttonColorWhite
        let att = [NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                   NSForegroundColorAttributeName: UIColor.white]
        let str = NSAttributedString(string: "退出登陆", attributes: att)
        b.setAttributedTitle(str, for: .normal)
        b.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return b
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupLogoutButton()
    }
    
    private func setupTableView(){
        tableView.register(UserSettingCell.self, forCellReuseIdentifier: userSettingCellId)
        view.addSubview(tableView)
        tableView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 40, width: 0, height: 0)
    }
    
    private func setupLogoutButton(){
        view.addSubview(logoutButton)
        logoutButton.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 40)
    }
    
    
}



extension UserSettingController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userSettingCellId, for: indexPath) as! UserSettingCell
        cell.titleLabel.text = titles[indexPath.section][indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}
