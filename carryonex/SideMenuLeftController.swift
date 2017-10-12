//
//  SideMenuLeftController.swift
//  carryonex
//
//  Created by Xin Zou on 8/9/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class SideMenuLeftController: UITableViewController {
    
    
    let cellId = "UserContentCellId"
    
    private let userInfoView = SideMenuUserInfoView()
    private let userInfoViewW: CGFloat = UIScreen.main.bounds.width - centerPanelExpandedOffset
    private let userInfoViewH : CGFloat = 80
    private let gap: CGFloat = 20
    
    private let logoutButtonH: CGFloat = 40
    
    lazy var logOutButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .red
        b.setTitle("Log Out", for: .normal)
        b.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        return b
    }()
    
    weak var containerDelegate : PageContainerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        setupUserInfoView()
        
        setupLogOutButton()
        
    }
    
    
    private func setupTableView(){
        
        tableView.register(SlideMenuLeftCell.self, forCellReuseIdentifier: cellId)
        tableView.contentInset = UIEdgeInsetsMake(userInfoViewH + gap, 0, 20, 0) // set range of tableView
        
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }
    
    private func setupUserInfoView(){
        view.addSubview(userInfoView)
        userInfoView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: -userInfoViewH - gap, rightConstent: 0, bottomConstent: 0, width: userInfoViewW, height: 80)
    }
    
    private func setupLogOutButton(){
        let logoutButtonOffset: CGFloat = UIScreen.main.bounds.height - userInfoViewH - 40
        view.addSubview(logOutButton)
        logOutButton.addConstraints(left: view.leftAnchor, top: nil, right: nil, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: -logoutButtonOffset, width: userInfoViewW, height: 40)
    }
    
    // MARK: Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SlideMenuLeftCell
        cell.titleLabel.text = "test row \(indexPath.row)"
        return cell
    }
    

    // Mark: Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SideMenuLeftController: select row: \(indexPath.row)")
    }
    
    
    
    
    
    func logOutButtonTapped(){
        containerDelegate?.toggleLeftPanel()
        print("should logout user and return to home page")
    }
    
    
}


