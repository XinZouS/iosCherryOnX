//
//  ItemListYouxiangInputController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/27.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import BPCircleActivityIndicator

class ItemListYouxiangInputController: UIViewController {
    
    var tripCode: String?
    
    @IBOutlet weak var youxiangcodeLabel: UILabel!
    @IBOutlet weak var youxiangcodeTextField: ThemTextField!
    @IBOutlet weak var goDetailButton: UIButton!
    
    @IBAction func goDetailPage(_ sender: Any) {
        guard let code = youxiangcodeTextField.text else { return }
        fetchTripByYouxiangcode(code)
    }
    
    let segueIdSenderDetailInfo = "goToSenderDetailInfoPage"
    var activityIndicator: BPCircleActivityIndicator!
    var isLoading: Bool = false {
        didSet{
            if isLoading {
                activityIndicator.isHidden = false
                activityIndicator.animate()
            } else {
                activityIndicator.isHidden = true
                activityIndicator.stop()
            }
            goDetailButton.isEnabled = !isLoading
        }
    }
    

    override func viewDidLoad() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupNavigationBar()
        setupTextFields()
        setupActivityIndicator()
        youxiangcodeTextField.keyboardType = .emailAddress
        
        if let tripCode = tripCode {
            youxiangcodeTextField.text = tripCode
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        youxiangcodeTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        youxiangcodeTextField.resignFirstResponder()        
    }
    
    private func setupNavigationBar(){
        title = "寄件"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupTextFields(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        textFieldAddToolBar(youxiangcodeTextField)
        youxiangcodeTextField.autocapitalizationType = .allCharacters
        youxiangcodeTextField.clearButtonMode = .never
        let att = [NSForegroundColorAttributeName: UIColor(white: 0.9, alpha: 1)]
        youxiangcodeTextField.attributedPlaceholder = NSAttributedString(string: "输入6位游箱号", attributes: att)
    }
    
    private func setupActivityIndicator(){
        activityIndicator = BPCircleActivityIndicator()
        activityIndicator.frame = CGRect(x:view.center.x-15,y:view.center.y-64,width:0,height:0)
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }
    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == segueIdSenderDetailInfo {
            return sender != nil
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let infoVC = segue.destination as? SenderDetailViewController,
            let tp = sender as? Trip {
            infoVC.trip = tp
        }
    }
    
    fileprivate func fetchTripByYouxiangcode(_ code: String){
        if isLoading {
            return
        }
        guard code.count == 6 else {
           self.displayGlobalAlert(title: "游箱号错误", message: "游箱号由6位数字或字母组成", action: L("action.ok"), completion: { [weak self] _ in
                self?.isLoading = false
                self?.youxiangcodeTextField.text = ""
                self?.youxiangcodeTextField.becomeFirstResponder()
            })
            return
        }
        isLoading = true
        goDetailButton.isEnabled = false

        ApiServers.shared.getTripInfo(id: code, completion: { (success, getTrip, error) in
            self.isLoading = false
            if let err = error, getTrip == nil {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                AudioManager.shared.playSond(named: .failed)
                self.displayGlobalAlert(title: "游箱号异常", message: "您搜索的游箱号不存在，或已被出行人关闭", action: "重新输入", completion: { [weak self] _ in
                    self?.youxiangcodeTextField.text = ""
                })
                print(err.localizedDescription)
                return
            }
            if success {
                if let trip = getTrip {
                    if trip.carrierId == ProfileManager.shared.getCurrentUser()?.id {
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                        AudioManager.shared.playSond(named: .failed)
                        self.displayAlert(title: "游箱号异常", message: "你不能使用自己的游箱号下单", action: L("action.ok"))
                        return
                    }
                    self.performSegue(withIdentifier: "goToSenderDetailInfoPage", sender: trip)
                }
            } else {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                AudioManager.shared.playSond(named: .failed)
                self.displayGlobalAlert(title: "游箱号异常", message: "由于网络连接有问题，您的请求无法发送，请重试", action: L("action.ok"), completion: nil)
            }
            self.goDetailButton.isEnabled = true
        })
    }
    

}

extension ItemListYouxiangInputController: UITextFieldDelegate {
    
    func textFieldDidChanged(){
        guard let code = youxiangcodeTextField.text else {
            return
        }
        youxiangcodeLabel.text = code.uppercased()
        if code.count == 6 {
            fetchTripByYouxiangcode(code)
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
        
        let allowChar = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        return string.rangeOfCharacter(from: allowChar) != nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let code = youxiangcodeTextField.text else { return false }
        fetchTripByYouxiangcode(code)
        return false
    }
    
    public func keyboardDidShow(){
        youxiangcodeTextField.isSecureTextEntry = true
    }
    
    fileprivate func textFieldAddToolBar(_ textField: UITextField) {
        let bar = UIToolbar()
        bar.barStyle = .default
        bar.isTranslucent = true
        bar.tintColor = .black
        
        let doneBtn = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(textFieldDoneButtonTapped))
        let cancelBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(textFieldCancelButtonTapped))
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.setItems([cancelBtn, spaceBtn, doneBtn], animated: false)
        bar.isUserInteractionEnabled = true
        bar.sizeToFit()
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        textField.inputAccessoryView = bar
    }
    func textFieldDoneButtonTapped(){
        youxiangcodeTextField.resignFirstResponder()
        textFieldDidChanged()
    }
    func textFieldCancelButtonTapped(){
        youxiangcodeTextField.resignFirstResponder()
    }
    

}
