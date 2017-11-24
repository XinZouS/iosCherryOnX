//
//  PersonalInfoEditingViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/21/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class PersonalInfoEditingViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let genderPickerView = UIPickerView()
    var pickerData: [String] = [String]()
    let titles = ["性别","电子邮件","身份证件"]
    var user: ProfileUser? {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var genderCell : PersonalInfoEditingCell?
    var emailCell : PersonalInfoEditingCell?
    
    override func viewDidLoad() {
        setupTableView()
        setupUser()
        setupNavigationBar()
        pickerData = ["男", "女", "其他"]
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderCell?.inputTextField.text = pickerData[genderPickerView.selectedRow(inComponent: 0)]
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() // remove empty rows;
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
    
    private func setupNavigationBar(){
        title = "编辑个人资料"
        let save = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = save
    }
    
    @objc private func saveButtonTapped(){
        
    }
    
    
    @IBAction func imageButtonTapped(_ sender: Any) {
    }
    
    
}

extension PersonalInfoEditingViewController: UITableViewDataSource,UITextFieldDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalInfoEditingCell", for: indexPath) as? PersonalInfoEditingCell{
            cell.titleLabel.text = titles[indexPath.row]
            var info = "detail info"
            let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0,y:0,width:320,height:50))
            doneToolbar.barStyle = UIBarStyle.blackTranslucent
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
            doneToolbar.items = [flexSpace,done]
            doneToolbar.sizeToFit()
            cell.inputTextField.inputAccessoryView = doneToolbar
            switch indexPath.row {
            case 0:
                genderCell = cell
                info = "Profile user: add Gender" // TODO
                cell.detailLabel.isHidden = true
                cell.inputTextField.placeholder = "性别"
                cell.inputTextField.inputView = genderPickerView
            case 1:
                emailCell = cell
                cell.detailLabel.isHidden = true
                info = user?.email ?? "我的E-mail"
                cell.inputTextField.placeholder = "邮箱"
                cell.inputTextField.delegate = self
            case 2:
                info = "提交"
                cell.inputTextField.isHidden = true
                cell.detailLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            default:
                print("err: PersonalInfoEditingViewController: invalidate info row...")
            }
            cell.detailLabel.text = info
        }
        return UITableViewCell()
    }
    
    func doneButtonAction()
    {
        genderCell?.inputTextField.resignFirstResponder()
        emailCell?.inputTextField.resignFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension PersonalInfoEditingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            genderCell?.inputTextField.becomeFirstResponder()
        case 1:
            emailCell?.inputTextField.becomeFirstResponder()
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
    @IBOutlet weak var inputTextField: UITextField!
}
