//
//  ItemListYouxiangInputController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/27.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import Material
import BPCircleActivityIndicator

class ItemListYouxiangInputController: UIViewController {
    
    @IBOutlet weak var youxiangcodeTextField: UITextField!
    @IBOutlet weak var goDetailButton: UIButton!
    
    @IBAction func goDetailPage(_ sender: Any) {
        guard let code = youxiangcodeTextField.text, code.count >= 0 else { // TODO: change to ==6 before launch!!!!!!!
            let m = "亲，游箱号是6位数字哦，😃请填写符合格式的号码。"
            displayGlobalAlert(title: "💡小提示", message: m, action: "好，朕知道了", completion: {
                self.youxiangcodeTextField.becomeFirstResponder()
            })
            return
        }
        fetchTripByYouxiangcode(code)
    }
    
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
        setupNavigationBar()
        setupTextFields()
        setupActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        youxiangcodeTextField.becomeFirstResponder()
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
        textFieldAddToolBar(youxiangcodeTextField)
        youxiangcodeTextField.autocapitalizationType = .allCharacters
    }
    
    private func setupActivityIndicator(){
        activityIndicator = BPCircleActivityIndicator()
        activityIndicator.frame = CGRect(x:view.center.x-15,y:view.center.y-15,width:0,height:0)
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }
    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToSenderDetailInfoPage" {
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
        isLoading = true
        ApiServers.shared.getTripInfo(id: code, completion: { (success, getTrip, error) in
            self.isLoading = false
            let t = "⚠️获取失败"
            if let err = error, getTrip == nil {
                let m = "无法查询此行程，请确保您所填写的游箱号正确。错误信息：\(err.localizedDescription)"
                self.displayGlobalAlert(title: t, message: m, action: "换个姿势再试一次", completion: {
                    self.youxiangcodeTextField.becomeFirstResponder()
                })
                return
            }
            if success {
                if let trip = getTrip {
                    self.performSegue(withIdentifier: "goToSenderDetailInfoPage", sender: trip)
                }
            } else {
                let m = "暂时无法连接服务器，请保持手机网络通畅，稍后再试。"
                self.displayGlobalAlert(title: t, message: m, action: "好，回主页", completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
        })
    }
    

}

extension ItemListYouxiangInputController: UITextFieldDelegate {
    
    func textFieldDidChanged(){
        guard let code = youxiangcodeTextField.text, code.count == 6 else {
            return
        }
        fetchTripByYouxiangcode(code)
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
