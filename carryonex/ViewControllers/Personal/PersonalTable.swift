//
//  PersonalTable.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/24.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class PersonalTable: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    let genderPickerView = UIPickerView()
    var pickerData: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["未知","男", "女", "其他"]
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self
        setupTextField()
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = false
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
        genderTextField.text = pickerData[genderPickerView.selectedRow(inComponent: 0)]
    }
    private func setupTextField(){
        genderTextField.inputView = genderPickerView
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0,y:0,width:320,height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [flexSpace,done]
        doneToolbar.sizeToFit()
        self.genderTextField.inputAccessoryView = doneToolbar
        self.emailTextField.inputAccessoryView = doneToolbar
    }
    
    @IBAction func commitButtonTapped(_ sender: Any) {
        let idCV = PhotoIDController()
        self.navigationController?.pushViewController(idCV, animated: true)
    }
    
    @objc private func doneButtonAction(){
        genderTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
}

