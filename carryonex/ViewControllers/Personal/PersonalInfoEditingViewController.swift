//
//  PersonalInfoEditingViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/21/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class PersonalInfoEditingViewController: UIViewController {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let titles = ["性别","电子邮件","身份证件"]
    var user: ProfileUser? {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        title = "编辑个人资料"
        setupTableView()
        setupUser()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUser(){
        if let getUser = ProfileManager.shared.getCurrentUser() {
            user = getUser
        } else {
            let m = "请保持网络连接，稍后再试一次。"
            displayGlobalAlert(title: "⚠️获取信息失败", message: m, action: "OK", completion: {
                print("TODO: handle error when GET user failed in PersonalInfoEditingViewController;")
            })
        }
    }
    
    
    @IBAction func imageButtonTapped(_ sender: Any) {
    }
    
    
}

extension PersonalInfoEditingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalInfoEditingCell", for: indexPath) as? PersonalInfoEditingCell {
            cell.titleLabel.text = titles[indexPath.row]
            var info = "detail info"
            switch indexPath.row {
            case 0:
                info = "Profile user: add Gender" // TODO
            case 1:
                info = user?.email ?? "我的E-mail"
            case 2:
                info = "提交"
                cell.detailLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            default:
                print("err: PersonalInfoEditingViewController: invalidate info row...")
            }
            cell.detailLabel.text = info
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


extension PersonalInfoEditingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("TODO: open picker for gender")
        case 1:
            print("TODO: open keyboard for email")
        case 2:
            let idCV = PhotoIDController()
            self.navigationController?.pushViewController(idCV, animated: true)
            
        default:
            print("err: PersonalInfoEditingViewController: invalidate info row...")
        }

    }
    
}


class PersonalInfoEditingCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailLabelRightConstraint: NSLayoutConstraint!
    
    
}
