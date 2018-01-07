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
    @IBOutlet weak var currencyMarkLabel: UILabel!
    @IBOutlet weak var cashAvailableLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var extractValueMinButton: UIButton!
    @IBOutlet weak var extractValueMidButton: UIButton!
    @IBOutlet weak var extractValueButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    var circleIndicator: BPCircleActivityIndicator!
    
    @IBAction func extractValueButtonTapped(_ sender: Any) {
        cashExtract = cashAvailable
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        guard let alipayId = alipayAccountTextField.text else {
            displayAlert(title: "账户错误", message: "请输入支付宝账号", action: L("action.ok"))
            return
        }
        
        guard let payoutAmount = cashExtractTextField.text, let payout = Double(payoutAmount), payout > cashExtract else {
            displayAlert(title: "提现金额错误", message: "请输入正确的提现金额", action:  L("action.ok"))
            return
        }
        
        self.circleIndicator.isHidden = false
        self.circleIndicator.animate()
        
        ApiServers.shared.postWalletAliPayout(logonId: alipayId, amount: payoutAmount) { (success, error) in
            //Fix this after server fixed.
            self.displayAlert(title: "提现成功", message: "我们已经成功转账到您的账户，请查看您的支付宝", action:  L("action.ok"))
        
            self.circleIndicator.stop()
            self.circleIndicator.isHidden = true
            
            //Reload data on this page
            ProfileManager.shared.updateWallet(completion: nil)
        }
    }
    
    var cashExtract: Double = 0.0 {
        didSet{
            cashExtractTextField.text = String(format: "%.2f", cashAvailable)
        }
    }
    
    var cashAvailable: Double = 0.0
    
    enum TextFieldTag: Int {
        case aliAccount = 0
        case aliName = 1
        case cashExtract = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L("personal.ui.title.cash")
        
        if let wallet = ProfileManager.shared.wallet {
            self.cashAvailableLabel.text = L("personal.ui.title.cash-extractable") + wallet.availableCredit()
        }
        
        setupTextFields()
        setupButtons()
        alipayAccountTextField.becomeFirstResponder()
        setupActivityIndicator()
        
        NotificationCenter.default.addObserver(forName: .WalletDidUpdate, object: nil, queue: nil) { [weak self] _ in
            if let wallet = ProfileManager.shared.wallet {
                self?.cashAvailableLabel.text = L("personal.ui.title.cash-extractable") + wallet.availableCredit()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUnderlines()
    }
    
    private func setupActivityIndicator(){
        circleIndicator = BPCircleActivityIndicator()
        circleIndicator.isHidden = true
        circleIndicator.center = CGPoint(x: view.center.x - 15, y: view.center.y - 60)
        view.addSubview(circleIndicator)
    }
    
    private func setupUnderlines(){
        let w: CGFloat = self.view.bounds.width
        let gray = colorTextFieldUnderLineLightGray
        let h: CGFloat = 1
        
        let line1: CGFloat = stackView.frame.origin.y - h
        containerView.drawStroke(startPoint: CGPoint(x: 0, y: line1), endPoint: CGPoint(x: w, y: line1), color: gray, lineWidth: h)
        let line2: CGFloat = stackView.frame.origin.y + stackView.frame.height + h
        containerView.drawStroke(startPoint: CGPoint(x: 0, y: line2), endPoint: CGPoint(x: w, y: line2), color: gray, lineWidth: h)
//        let line3: CGFloat = 246
//        containerView.drawStroke(startPoint: CGPoint(x: 0, y: line3), endPoint: CGPoint(x: w, y: line3), color: gray, lineWidth: h)
    }
    
    private func setupButtons(){
        extractValueMinButton.setTitle(L("personal.ui.title.min-button"), for: .normal)
        extractValueMidButton.setTitle(L("personal.ui.title.mid-button"), for: .normal)
        extractValueButton.setTitle(L("personal.ui.title.value-button"), for: .normal)
        doneButton.setTitle(L("personal.ui.title.done-button"), for: .normal)
        setDoneButton(isActive: false)
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
        
        let doneBtn = UIBarButtonItem(title: L("action.done"), style: .done, target: self, action: #selector(textFieldDoneButtonTapped(_:)))
        let cancelBtn = UIBarButtonItem(title: L("action.cancel"), style: .plain, target: self, action: #selector(textFieldCancelButtonTapped(_:)))
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
        ///BUG TODO: this doesn't work...why??? It also doesn't work in DoneButtonTapped(textField)  - Xin
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
    
    fileprivate func setDoneButton(isActive: Bool) {
        doneButton.isEnabled = isActive
        doneButton.setTitleColor(isActive ? UIColor.white : UIColor.gray, for: .normal)
        doneButton.backgroundColor = isActive ? colorTheamRed : colorLineLightGray
    }
    

}

extension AlipayCashExtract: UITextFieldDelegate {
    
    public func textFieldDidChange(_ textField: UITextField) {
        // check for extractValue <= cashAvailable:
        //TODO: Add this check in later.
        guard textField == cashExtractTextField else { return }
        let v: Double = Double(textField.text ?? "0.0") ?? 0.0
        let isAvailable = cashAvailable >= v && v > 0.00
        setDoneButton(isActive: isAvailable)
        if !isAvailable {
            textField.text = String(format: "%.2f", cashAvailable)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // check for backspace key
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
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
