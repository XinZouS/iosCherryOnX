//
//  AddressController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

extension AddressController: UITextFieldDelegate {
    
    func areaMenuOKButtonTapped(){
        print("provinceMenuPickerOKButtonTapped")
        provinceCell.textField.text = self.addressArray[provinceIndex]["state"] as? String
        address.state = self.addressArray[provinceIndex]["state"] as? String
        let province = self.addressArray[provinceIndex]
        let city = (province["cities"] as! NSArray)[cityIndex]
            as! [String: AnyObject]
        cityCell.textField.text = city["city"] as? String
        address.city = city["city"] as? String
        if (indexOfCountry == 0 && provinceIndex > 3){
            let areaPlace = (city["areas"] as! NSArray)[areaIndex]
            addressDetailCell.textView.text = areaPlace as? String
        }
    }
    
    func selectCountry(){
        switch(indexOfCountry){
        case 0:
            let path = Bundle.main.path(forResource: "addressCN", ofType:"plist")
            self.addressArray = NSArray(contentsOfFile: path!) as! Array
        case 1:
            let path = Bundle.main.path(forResource: "addressUS", ofType:"plist")
            self.addressArray = NSArray(contentsOfFile: path!) as! Array
        default:
            break;
        }
    }
    
    func areaMenuCancelButtonTapped(){
        print("provinceMenuPickerOKButtonTapped")
        areaPickerMenu?.dismissAnimation()
    }
    
    func openVolumePicker(){
        pickerView.isHidden = !pickerView.isHidden
        // will hide when begin to set area
    }
    
    
    func okButtonTapped(){
        print("TODO: upload all data and update to PostTripController!!! view.height = \(view.bounds.height)!!!")
        navigationController?.popViewController(animated: true)
        address.country =  countryCell.selectedLabel.text.map { Country(rawValue: $0) }!
        address.state = provinceCell.textField.text
        address.city = cityCell.textField.text
        address.detailAddress = addressDetailCell.textView.text
        address.zipcode = zipcodeCell.textField.text
        address.recipientName = recipientNameCell.textField.text
        address.phoneNumber = recipientPhoneCell.textField.text
    }
    
    func cancelButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        transparentView.isHidden = false
        textField.becomeFirstResponder()
    }
    
    func textFieldsInAllCellResignFirstResponder(){
        transparentView.isHidden = true
        addressDetailCell.textView.resignFirstResponder()
        zipcodeCell.textField.resignFirstResponder()
        recipientNameCell.textField.resignFirstResponder()
        recipientPhoneCell.textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if touches.count > 0 {
            textFieldsInAllCellResignFirstResponder()
        }
    }
    
    func changeUIforCountry(){
        
    }
    
}
