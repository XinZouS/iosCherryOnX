//
//  ItemListYouxiangInputController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/27.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class ItemListYouxiangInputController: UIViewController {
    
    var tripCode: String? {
        didSet {
            if youxiangcodeTextField != nil {
                youxiangcodeTextField.text = tripCode
                if let tripCode = tripCode, tripCode.count == 6 {
                    fetchTripByYouxiangcode(tripCode)
                    return
                }
            }
        }
    }
    
    @IBOutlet weak var youxiangcodeTextField: ThemTextField!
    @IBOutlet weak var goDetailButton: UIButton!
    
    @IBAction func goDetailPage(_ sender: Any) {
        guard let code = youxiangcodeTextField.text else { return }
        fetchTripByYouxiangcode(code)
    }
    
    let segueIdSenderDetailInfo = "goToSenderDetailInfoPage"
    let segueRequestTripVC = "RequestSegue"
    
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
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTextFields()
        setupActivityIndicator()
        
        if let code = tripCode {
            youxiangcodeTextField.text = code
            if code.count == 6 {
                fetchTripByYouxiangcode(code)
                return
            }
        }
        AnalyticsManager.shared.startTimeTrackingKey(.senderCompleteTripidTime)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigationBar()
        youxiangcodeTextField.becomeFirstResponder()
        textFieldDidChanged(youxiangcodeTextField)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        youxiangcodeTextField.resignFirstResponder()
        AnalyticsManager.shared.finishTimeTrackingKey(.senderCompleteTripidTime)
    }
    
    private func setupNavigationBar(){
        title = L("sender.ui.title.new-request")
        navigationController?.navigationBar.backItem?.title = " "
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupTextFields(){
        textFieldAddToolBar(youxiangcodeTextField)
        youxiangcodeTextField.autocapitalizationType = .allCharacters
        youxiangcodeTextField.clearButtonMode = .never
        youxiangcodeTextField.placeholder = L("sender.ui.placeholder.new-code")
        youxiangcodeTextField.textColor = .white
        youxiangcodeTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    private func setupActivityIndicator(){
        activityIndicator = BPCircleActivityIndicator()
        activityIndicator.center = CGPoint(x: view.center.x - 15, y: view.center.y - 60)
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }
    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == segueIdSenderDetailInfo {
            return sender != nil
        }
        if identifier == segueRequestTripVC {
            return sender != nil
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if let infoVC = segue.destination as? SenderDetailViewController,
        //    let tp = sender as? Trip {
        //    infoVC.trip = tp
        //} use a new VC to display trip info before enter the SenderDetailVC:
        if let reqVC = segue.destination as? RequestTripViewController, let tp = sender as? Trip {
            title = " "
            reqVC.trip = tp
        }
    }
    
    fileprivate func fetchTripByYouxiangcode(_ code: String){
        if isLoading {
            return
        }
        
        guard code.count == 6 else {
            self.isLoading = false
            self.displayGlobalAlert(title: L("sender.error.title.youxiangcode-type"),
                                    message: L("sender.error.message.youxiangcode-type"),
                                    action: L("action.ok"), completion: { _ in
            })
            return
        }
        
        isLoading = true
        goDetailButton.isEnabled = false

        ApiServers.shared.getTripInfo(id: code, completion: { (success, getTrip, error) in
            self.isLoading = false
            if getTrip == nil {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                AudioManager.shared.playSond(named: .failed)
                self.displayGlobalAlert(title: L("sender.error.title.youxiangcode"), message: L("sender.error.message.youxiangcode-invalidate"), action: L("sender.error.action.youxiangcode-invalidate"), completion: { [weak self] _ in
                    self?.resetTextField()
                })
                return
            }
            
            if success {
                if let trip = getTrip {
                    
                    if trip.carrierId == ProfileManager.shared.getCurrentUser()?.id {
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                        AudioManager.shared.playSond(named: .failed)
                        self.displayAlert(title: L("sender.error.title.youxiangcode"), message: L("sender.error.message.youxiangcode-self-deny"), action: L("action.ok"))
                        self.resetTextField()
                        return
                    }
                    //self.performSegue(withIdentifier: "goToSenderDetailInfoPage", sender: trip)
                    self.performSegue(withIdentifier: self.segueRequestTripVC, sender: trip)
                }
                
            } else {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                AudioManager.shared.playSond(named: .failed)
                self.displayGlobalAlert(title: L("sender.error.title.youxiangcode"), message: L("sender.error.message.youxiangcode-network"), action: L("action.ok"), completion: nil)
                self.goDetailButton.isEnabled = true
            }
        })
    }
    
    private func resetTextField(){
        youxiangcodeTextField.tintColor = colorTextFieldUnderLineCyan
        youxiangcodeTextField.text = ""
        youxiangcodeTextField.becomeFirstResponder()
        goDetailButton.isEnabled = true
    }

}

extension ItemListYouxiangInputController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let code = youxiangcodeTextField.text else { return false }
        fetchTripByYouxiangcode(code)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidChanged(_ textField: UITextField) {
        if let t = textField.text, t.count > 5 {
            goDetailButton.isHidden = false
        }else{
            goDetailButton.isHidden = true
        }
    }
    
    fileprivate func textFieldAddToolBar(_ textField: UITextField) {
        let bar = UIToolbar()
        bar.barStyle = .default
        bar.isTranslucent = true
        bar.tintColor = .black
        
        let doneBtn = UIBarButtonItem(title: L("action.done"), style: .done, target: self, action: #selector(textFieldDoneButtonTapped))
        let cancelBtn = UIBarButtonItem(title: L("action.cancel"), style: .plain, target: self, action: #selector(textFieldCancelButtonTapped))
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.setItems([cancelBtn, spaceBtn, doneBtn], animated: false)
        bar.isUserInteractionEnabled = true
        bar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = bar
    }
    
    func textFieldDoneButtonTapped(){
        youxiangcodeTextField.resignFirstResponder()
        guard let code = youxiangcodeTextField.text else { return }
        fetchTripByYouxiangcode(code)
    }
    
    func textFieldCancelButtonTapped(){
        youxiangcodeTextField.resignFirstResponder()
    }
    
}
