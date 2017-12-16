//
//  PhoneNumViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/14/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import BPCircleActivityIndicator

class PhoneNumViewController: UIViewController {
    
    var isModifyPhoneNumber = false
    var loginStatus: LoginStatus = .unknow
    var zoneCodeInput = "1"
    var phoneInput = ""

    let segueIdChangePw = "changePassword"
    let segueIdVerifyVC = "gotoPhoneVerifyVC"
    
    var isPhoneNumValid: Bool = false
    var isLoading: Bool = false {
        didSet{
            if isLoading {
                loadingIndicator.isHidden = false
                loadingIndicator.animate()
                flagPicker.isHidden = true
            } else {
                loadingIndicator.isHidden = true
                loadingIndicator.stop()
            }
            countryCodeButton.isEnabled = !isLoading
            phoneNumTextField.isEnabled = !isLoading
        }
    }
    
    
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomImageView: UIImageView!
    var loadingIndicator: BPCircleActivityIndicator!
    
    
    var transparentView : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .clear
        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
        return v
    }()
    
    lazy var flagPicker: UIPickerView = {
        let p = UIPickerView()
        p.backgroundColor = pickerColorLightGray
        p.dataSource = self
        p.delegate = self
        p.isHidden = false
        return p
    }()
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        zoneCodeInput = "1"

        setupTextField()
        setupFlagPicker()
        checkPhone()
        setupGifImage()
        setupActivityIndicator()
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        
        addObservers()
    }
    
    // for keyboard notification:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = phoneNumTextField.becomeFirstResponder()
        navigationController?.isNavigationBarHidden = isModifyPhoneNumber
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        navigationController?.isNavigationBarHidden = false
        countryCodeButton.isEnabled = true
        phoneNumTextField.isEnabled = true
        sendButton.isEnabled = true
    }
    
    
    //MARK: - View custom set up

    private func setupTextField(){
        phoneNumTextField.delegate = self
        phoneNumTextField.addTarget(self, action: #selector(checkPhone), for: .editingChanged)
    }
    
    private func setupFlagPicker(){
        view.addSubview(flagPicker)
        flagPicker.addConstraints(left: bottomImageView.leftAnchor, top: bottomImageView.topAnchor, right: bottomImageView.rightAnchor, bottom: bottomImageView.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    private func setupActivityIndicator(){
        loadingIndicator = BPCircleActivityIndicator()
        loadingIndicator.frame = CGRect(x:view.center.x-15,y:view.center.y-105,width:0,height:0)
        loadingIndicator.isHidden = true
        view.addSubview(loadingIndicator)
    }
    
    private func setupGifImage(){
        let gifImg = UIImage.gifImageWithName("Login_animated_loop_png")
        bottomImageView.image = gifImg
    }

    
    //MARK: - Action Handler
    
    @IBAction func countryCodeButtonTapped(_ sender: UIButton) {
        openFlagPicker()
        phoneNumTextField.resignFirstResponder()
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        prepareVerifyPhoneNum()
    }
}




extension PhoneNumViewController: PhoneNumberDelegate {
    
    func prepareVerifyPhoneNum() {
        guard let newPhone = phoneNumTextField.text else {
            let m = "您还没填写电话号码呢！"
            displayGlobalAlert(title: "❓缺少信息", message: m, action: L("action.ok"), completion: nil)
            return
        }
        
        isLoading = true
        ApiServers.shared.getIsUserExisted(phoneInput: newPhone) { (isExist, error) in
            self.isLoading = false
            
            if let error = error {
                print("getIsUserExisted error: \(error.localizedDescription)")
                return
            }
            if isExist {
                switch self.loginStatus {
                case .modifyPhone :
                    self.modifyUserPhoneNum(newPhone)
                    
                case .changePassword:
                    self.verifyUserNewPhoneNum()
                    
                default:
                    self.loginByPasswordInput()
                }
            } else { // is new phone: 
                self.verifyUserNewPhoneNum()
            }
        }
    }
    
    private func modifyUserPhoneNum(_ newPhone: String){
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("nextButtonTapped error: Profile has no current user")
            return
        }
        phoneInput = profileUser.phone ?? ""
        zoneCodeInput = profileUser.phoneCountryCode ?? ""
        
        self.isLoading = true
        verifyUserNewPhoneNum()
    }
    
    private func loginByPasswordInput(){
        let m = "您所使用的手机号已注册，请使用密码登陆即可。"
        displayGlobalAlert(title: "⚠️不能注册", message: m, action: "去登陆") {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func verifyUserNewPhoneNum(){
        self.isLoading = true
        
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phoneInput, zone: zoneCodeInput, result: { (err) in
            self.isLoading = false
            if let err = err {
                print("PhoneNumViewController: lgoin有错误: \(String(describing: err))")
                let msg = "未能发送验证码，请确认手机号与地区码输入正确，换个姿势稍后重试。错误信息：\(String(describing: err))"
                self.displayGlobalAlert(title: "获取验证码失败", message: msg, action: L("action.ok"), completion: nil)
                return
            }
            self.goToVerificationPage()
        })
    }
    
    @objc private func nextButtonEnable(){
        sendButton.isEnabled = true
        sendButton.backgroundColor = colorOkgreen
    }
    
    func textFieldsInAllCellResignFirstResponder(){
        transparentView.isHidden = true
        phoneNumTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if touches.count > 0 {
            textFieldsInAllCellResignFirstResponder()
        }
    }
    
    func showUserAgreementPage(){
        let disCtrlView = DisclaimerController()
        self.navigationController?.pushViewController(disCtrlView, animated: true)
    }
    
    func goToVerificationPage(){
        let info: [String:String] = [
            "countryCode" : zoneCodeInput,
            "phone" : phoneInput,
            ]
        switch loginStatus {
        case .changePassword :
            performSegue(withIdentifier: segueIdChangePw, sender: info)
        default:
            performSegue(withIdentifier: segueIdVerifyVC, sender: info)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdVerifyVC {
            if let vldVC = segue.destination as? PhoneValidationViewController,
                let info = sender as? [String:String] {
                vldVC.registerUserInfo = info
            }
        }
        if segue.identifier == segueIdChangePw {
            if let vldVC = segue.destination as? PhoneValidationViewController,
                let info = sender as? [String:String] {
                vldVC.registerUserInfo = info
                vldVC.status = LoginStatus.changePassword
            }
        }
    }

    
    // MARK: delegate: go back to home page
    
    func dismissAndReturnToHomePage(){
        self.navigationController?.popToRootViewController(animated: false)
        self.dismiss(animated: true) {
            print("go back to home page.")
        }
    }
    
    func cancelButtonTapped(){
        if self.navigationController?.viewControllers.count == 1 {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }

}


// MARK: - textField and keyboard
extension PhoneNumViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _ = phoneNumTextField.becomeFirstResponder()
        flagPicker.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkPhone()
        phoneNumTextField.resignFirstResponder()
    }
    
    func checkPhone(){
        var phonePattern = ""
        switch zoneCodeInput {
        case "86":
            phonePattern = "^1[0-9]{10}$"
        case "1":
            phonePattern = "^[0-9]{10}$"
        default:
            phonePattern = "^[0-9]{10}$"
        }
        let matcher = MyRegex(phonePattern)
        phoneInput = phoneNumTextField.text ?? ""
        
        let isFormatOK = matcher.match(input: phoneInput)
        
        isPhoneNumValid = isFormatOK
        sendButton.isEnabled = isFormatOK
        sendButton.backgroundColor = sendButton.isEnabled ? colorOkgreen : colorErrGray
        
        let msg = isFormatOK ? "电话格式正确" : "电话格式有误"
        print(msg + ": \(zoneCodeInput) \(phoneInput)")
    }
    
    private func updateNextButton(){
        guard let num = phoneNumTextField.text else { return }
        isPhoneNumValid = (num.count >= 6)
        if isPhoneNumValid {
            sendButton.isEnabled = isPhoneNumValid
            sendButton.backgroundColor = sendButton.isEnabled ? buttonThemeColor : .lightGray
        }
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func keyboardDidShow(){
        flagPicker.isHidden = true
    }
    
    func keyboardDidHide(){
        
    }
    
}


    // MARK: pickerView delegate
extension PhoneNumViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func openFlagPicker(){
        flagPicker.isHidden = !flagPicker.isHidden
        // will hide when begin to set phoneNum
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return flagsTitle.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return flagsTitle[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        zoneCodeInput = codeOfFlag[flagsTitle[row]]!
        countryCodeButton.setTitle("+" + zoneCodeInput, for: .normal)
        checkPhone()
    }
    
    
}



// MARK: - for ALL country code use
extension PhoneNumViewController {
    
    class CountryPhoneCodeAndName: NSObject {
        
        var countryWithCode = [CountryNameWithCode]()
        
        let countryDictionary = ["AF":"93", "AL":"355", "DZ":"213","AS":"1", "AD":"376", "AO":"244", "AI":"1","AG":"1","AR":"54","AM":"374","AW":"297","AU":"61","AT":"43","AZ":"994","BS":"1","BH":"973","BD":"880","BB":"1","BY":"375","BE":"32","BZ":"501","BJ":"229","BM":"1","BT":"975","BA":"387","BW":"267","BR":"55","IO":"246","BG":"359","BF":"226","BI":"257","KH":"855","CM":"237","CA":"1","CV":"238","KY":"345","CF":"236","TD":"235","CL":"56","CN":"86","CX":"61","CO":"57","KM":"269","CG":"242","CK":"682","CR":"506","HR":"385","CU":"53","CY":"537","CZ":"420","DK":"45","DJ":"253","DM":"1","DO":"1","EC":"593","EG":"20","SV":"503","GQ":"240","ER":"291","EE":"372","ET":"251","FO":"298","FJ":"679","FI":"358","FR":"33","GF":"594","PF":"689","GA":"241","GM":"220","GE":"995","DE":"49","GH":"233","GI":"350","GR":"30","GL":"299","GD":"1","GP":"590","GU":"1","GT":"502","GN":"224","GW":"245","GY":"595","HT":"509","HN":"504","HU":"36","IS":"354","IN":"91","ID":"62","IQ":"964","IE":"353","IL":"972","IT":"39","JM":"1","JP":"81","JO":"962","KZ":"77","KE":"254","KI":"686","KW":"965","KG":"996","LV":"371","LB":"961","LS":"266","LR":"231","LI":"423","LT":"370","LU":"352","MG":"261","MW":"265","MY":"60","MV":"960","ML":"223","MT":"356","MH":"692","MQ":"596","MR":"222","MU":"230","YT":"262","MX":"52","MC":"377","MN":"976","ME":"382","MS":"1","MA":"212","MM":"95","NA":"264","NR":"674","NP":"977","NL":"31","AN":"599","NC":"687","NZ":"64","NI":"505","NE":"227","NG":"234","NU":"683","NF":"672","MP":"1","NO":"47","OM":"968","PK":"92","PW":"680","PA":"507","PG":"675","PY":"595","PE":"51","PH":"63","PL":"48","PT":"351","PR":"1","QA":"974","RO":"40","RW":"250","WS":"685","SM":"378","SA":"966","SN":"221","RS":"381","SC":"248","SL":"232","SG":"65","SK":"421","SI":"386","SB":"677","ZA":"27","GS":"500","ES":"34","LK":"94","SD":"249","SR":"597","SZ":"268","SE":"46","CH":"41","TJ":"992","TH":"66","TG":"228","TK":"690","TO":"676","TT":"1","TN":"216","TR":"90","TM":"993","TC":"1","TV":"688","UG":"256","UA":"380","AE":"971","GB":"44","US":"1", "UY":"598","UZ":"998","VU":"678","WF":"681","YE":"967","ZM":"260","ZW":"263","BO":"591","BN":"673","CC":"61","CD":"243","CI":"225","FK":"500","GG":"44","VA":"379","HK":"852","IR":"98","IM":"44","JE":"44","KP":"850","KR":"82","LA":"856","LY":"218","MO":"853","MK":"389","FM":"691","MD":"373","MZ":"258","PS":"970","PN":"872","RE":"262","RU":"7","BL":"590","SH":"290","KN":"1","LC":"1","MF":"590","PM":"508","VC":"1","ST":"239","SO":"252","SJ":"47","SY":"963","TW":"886","TZ":"255","TL":"670","VE":"58","VN":"84","VG":"284","VI":"340"]
        
        func getCountryName() {
            // Sorting all keys
            let keys = countryDictionary.keys
            let keysValue = keys.sorted { (first, second) -> Bool in
                let key1: String = first
                let key2: String = second
                let result = key1.compare(key2) == .orderedAscending
                return result
            }
            print(keysValue)
            
            for key in keysValue {
                let countryKeyValue = CountryNameWithCode()
                print(countryDictionary[key] ?? "not")
                countryKeyValue.countryCode = countryDictionary[key]!
                countryKeyValue.countryName = Locale.current.localizedString(forRegionCode: key)!
                print(Locale.current.localizedString(forRegionCode: key)!)
                countryWithCode.append(countryKeyValue)
            }
        }
        
        class CountryNameWithCode: NSObject {
            var countryName = ""
            var countryCode = ""
            
        }
    }
}

