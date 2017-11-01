//
//  PhoneNumberController.swift
//  carryonex
//
//  Created by Xin Zou on 8/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//
// page: 1.1

import UIKit
import M13Checkbox
import Material

class PhoneNumberController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var phoneNumberTextField : TextField!
    var isPhoneNumValid: Bool = false
    var isLoading: Bool = false {
        didSet{
            if isLoading {
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    var transparentView : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .clear
        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
        return v
    }()

    lazy var flagPicker: UIPickerView = {
        let p = UIPickerView()
        //p.backgroundColor = .yellow
        p.dataSource = self
        p.delegate = self
        p.isHidden = false
        return p
    }()
    
    lazy var flagButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        b.layer.borderColor = UIColor.lightGray.cgColor
        b.layer.borderWidth = 1
        b.layer.cornerRadius = 5
        b.setTitle("🇺🇸  +1", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.borderColor = .clear
        b.addTarget(self, action: #selector(openFlagPicker), for: .touchUpInside)
        return b
    }()
    
    let textFieldH : CGFloat = 30
    
    lazy var agreeCheckbox : M13Checkbox = {
        let b = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 15.0))
        b.addTarget(self, action: #selector(agreeCheckboxChanged), for: .valueChanged)
        return b
    }()
    
    let agreeLabel : UILabel = {
        let b = UILabel()
        b.backgroundColor = .white
        b.text = "我已阅读并同意"
        b.textAlignment = .right
        b.font = UIFont.systemFont(ofSize: 12)
        return b
    }()
    
    lazy var nextButton : UIButton = {
        let b = UIButton()
        b.setTitle("→", for: .normal)
        b.layer.cornerRadius = 30
        b.backgroundColor = .lightGray
        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        b.isEnabled = false
        return b
    }()
    
    lazy var agreeButton : UIButton = {
        let attributes : [String: Any] = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName : UIColor.blue,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
        ]
        let attributeString = NSMutableAttributedString(string: "用户协议", attributes: attributes)
        
        let b = UIButton()
        b.backgroundColor = .white
        b.setAttributedTitle(attributeString, for: .normal)
        b.addTarget(self, action: #selector(showUserAgreementPage), for: .touchUpInside)
        return b
    }()
    
    var loadingIndicator: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
        
    // for keyboard notification:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObserver()
        _ = phoneNumberTextField.becomeFirstResponder()
        navigationController?.isNavigationBarHidden = !isModifyPhoneNumber
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
//        setupOkButton() // the order of this 3 is NOT allow to change!
        setupPhoneNumTextField()
        setupFlagButton()
        setupFlagPicker()
        if isModifyPhoneNumber == false {
            setupAgreeItems()
        }
//        setupDevelopButton()
        setupnextButton()
        setupLoadingIndicator()
    }
    
    
    private func setupNavigationBar(){
        UINavigationBar.appearance().tintColor = buttonColorWhite
        navigationController?.navigationBar.tintColor = buttonColorWhite
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: buttonColorWhite]
        title = "输入手机"
        
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func setupnextButton(){
        var h = 0,w = 0
        switch UIScreen.main.bounds.width {
        case 320:
            h = 30
            w = 130
        case 375:
            h = 80
            w = 150
        case 414:
            h = 120
            w = 180
        default:
            h = 120
            w = 180
        }
        view.addSubview(nextButton)
        nextButton.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 30, width: 60, height: 60)
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: CGFloat(w)).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(h)).isActive = true
    }
    
    private func setupPhoneNumTextField(){
        phoneNumberTextField = TextField()
        phoneNumberTextField.placeholder = "请输入手机号"
        phoneNumberTextField.detail = "手机号码"
        phoneNumberTextField.keyboardAppearance = .dark
        phoneNumberTextField.clearButtonMode = .whileEditing
        phoneNumberTextField.addTarget(self, action: #selector(checkPhone), for: .editingChanged)
        phoneNumberTextField.keyboardType = .numberPad
        view.layout(phoneNumberTextField).center(offsetY: -120).left(100).right(20)
    }
    
    
    private func setupFlagButton(){
        view.addSubview(flagButton)
        flagButton.addConstraints(left: nil, top: nil, right: phoneNumberTextField.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 76, height: textFieldH)
        flagButton.centerYAnchor.constraint(equalTo: phoneNumberTextField.centerYAnchor).isActive = true
    }
    
    private func setupFlagPicker(){
        view.addSubview(flagPicker)
        flagPicker.addConstraints(left: view.leftAnchor, top: view.centerYAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 20, topConstent: 60, rightConstent: 20, bottomConstent: 0, width: 0, height: 200)
    }
    
    private func setupAgreeItems(){
        view.addSubview(agreeLabel)
        agreeLabel.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 400, width: 90, height: 20)
        agreeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -10).isActive = true
        agreeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        view.addSubview(agreeButton)
        agreeButton.addConstraints(left: agreeLabel.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: 1, topConstent: 0, rightConstent: 0, bottomConstent: 10, width: 72, height: 30)
        agreeButton.centerYAnchor.constraint(equalTo: agreeLabel.centerYAnchor).isActive = true
        
        view.addSubview(agreeCheckbox)
        agreeCheckbox.addConstraints(left: nil, top: nil, right: agreeLabel.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 20, height: 20)
        agreeCheckbox.centerYAnchor.constraint(equalTo: agreeLabel.centerYAnchor).isActive = true
    }

    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}



// MARK: for ALL country code use

extension PhoneNumberController {

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

