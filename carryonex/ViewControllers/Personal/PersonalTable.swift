//
//  PersonalTable.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/24.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class PersonalTable: UITableViewController, UIPickerViewDataSource {
    
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    let genderPickerView = UIPickerView()
    var pickerData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = [L("personal.ui.title.gender-unknow"),
                      L("personal.ui.title.gender-male"),
                      L("personal.ui.title.gender-female"),
                      L("personal.ui.title.gender-other")] // ["未知","男", "女", "其他"]
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self
        setupTextField()
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = false
    }
    
    private func setupTextField(){
        genderTextField.inputView = genderPickerView
        let traits = genderTextField.value(forKey: "textInputTraits") as AnyObject
        traits.setValue(UIColor.clear, forKey: "insertionPointColor")

        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: L("action.done"), style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [flexSpace,done]
        doneToolbar.sizeToFit()
        
        self.genderTextField.inputAccessoryView = doneToolbar
        self.emailTextField.inputAccessoryView = doneToolbar
    }
    
    @IBAction func genderButtonTapped(_ sender: Any) {
        genderTextField.becomeFirstResponder()
    }
    
        
}

extension PersonalTable: UIPickerViewDelegate {
    
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
    
    @IBAction func commitButtonTapped(_ sender: Any) {
        let idCV = PhotoIDController()
        self.navigationController?.pushViewController(idCV, animated: true)
    }
    
    @objc func doneButtonAction(){
        genderTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
}

