//
//  AlipayCashExtractViewController.swift
//  carryonex
//
//  Created by Xin Zou on 12/5/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class AlipayCashExtract: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var alipayAccountTextField: UITextField!
    @IBOutlet weak var alipayNameTextField: UITextField!
    @IBOutlet weak var cashExtractTextField: UITextField!
    @IBOutlet weak var cashAvailableLabel: UILabel!
    @IBOutlet weak var extractValueButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func extractValueButtonTapped(_ sender: Any) {
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        // TODO: doneButtonTapped;
    }
    
    enum TextFieldTag: Int {
        case aliAccount = 0
        case aliName = 1
        case cashExtract = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "支付宝提现"
        
        setupUnderlines()
        setupTextFields()
        cashExtractTextField.becomeFirstResponder()
    }
    
    private func setupUnderlines(){
        let w: CGFloat = self.view.bounds.width
        let gray = colorLineLightGray
        let h: CGFloat = 1
        
        let line1: CGFloat = 72
        containerView.drawStroke(startPoint: CGPoint(x: 0, y: line1), endPoint: CGPoint(x: w, y: line1), color: gray, lineWidth: h)
        let line2: CGFloat = 134
        containerView.drawStroke(startPoint: CGPoint(x: 0, y: line2), endPoint: CGPoint(x: w, y: line2), color: gray, lineWidth: h)
        let line3: CGFloat = 246
        containerView.drawStroke(startPoint: CGPoint(x: 0, y: line3), endPoint: CGPoint(x: w, y: line3), color: gray, lineWidth: h)
    }
    
    private func setupTextFields(){
        textFieldAddToolBar(alipayAccountTextField, tag: .aliAccount)
        textFieldAddToolBar(alipayNameTextField, tag: .aliName)
        textFieldAddToolBar(cashExtractTextField, tag: .cashExtract)
    }

    fileprivate func textFieldAddToolBar(_ textField: UITextField?, tag: TextFieldTag) {
        if let tf = textField {
            tf.tag = tag.rawValue
            tf.delegate = self
            tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            tf.inputAccessoryView = setupToolBar()
        }
    }
    
    private func setupToolBar() -> UIToolbar {
        let bar = UIToolbar()
        bar.barStyle = .default
        bar.isTranslucent = true
        bar.tintColor = .black
        
        let doneBtn = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(textFieldDoneButtonTapped(_:)))
        let cancelBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(textFieldCancelButtonTapped(_:)))
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.setItems([cancelBtn, spaceBtn, doneBtn], animated: false)
        bar.isUserInteractionEnabled = true
        bar.sizeToFit()
        
        return bar
    }
    
    func textFieldDoneButtonTapped(_ textField: UITextField){
        keyboardDismiss()
    }
    
    func textFieldCancelButtonTapped(_ textField: UITextField){
        ///BUG TODO: this doesn't work...why??? - Xin
//        print("get cancel on txFd.tag = \(textField.tag)")
//        switch textField.tag {
//        case TextFieldTag.aliAccount.rawValue:
//            alipayAccountTextField.text = ""
//
//        case TextFieldTag.aliName.rawValue:
//            alipayNameTextField.text = ""
//
//        case TextFieldTag.cashExtract.rawValue:
//            cashExtractTextField.text = ""
//
//        default:
            keyboardDismiss()
//        }
    }
    

}

extension AlipayCashExtract: UITextFieldDelegate {
    
    public func textFieldDidChange(_ textField: UITextField) {
        //
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // check for decimal 6.66:
        guard textField == cashExtractTextField else {
            return true
        }
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let expression = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        let allowCommentAndWitespace = NSRegularExpression.Options.allowCommentsAndWhitespace
        let reportProgress = NSRegularExpression.MatchingOptions.reportProgress
        let regex = try! NSRegularExpression(pattern: expression, options: allowCommentAndWitespace)
        let numberOfMatches = regex.numberOfMatches(in: newString, options: reportProgress, range: NSMakeRange(0, (newString as NSString).length))
        
        return numberOfMatches != 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case TextFieldTag.aliAccount.rawValue:
            alipayNameTextField.becomeFirstResponder()
            
        case TextFieldTag.aliName.rawValue:
            cashExtractTextField.becomeFirstResponder()
            
        case TextFieldTag.cashExtract.rawValue:
            cashExtractTextField.resignFirstResponder()
            
        default:
            keyboardDismiss()
        }
        return false
    }
    
    fileprivate func keyboardDismiss(){
        alipayAccountTextField.resignFirstResponder()
        alipayNameTextField.resignFirstResponder()
        cashExtractTextField.resignFirstResponder()
    }
    
}
