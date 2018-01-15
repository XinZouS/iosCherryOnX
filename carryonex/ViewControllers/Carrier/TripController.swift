//
//  TripController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/19.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class TripController: UIViewController{
    
    let segueIdTripComplete = "tripComplete"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var startAddressTitleLabel: UILabel!
    @IBOutlet weak var startAddressTextField: ThemTextField!
    @IBOutlet weak var endAddressTitleLabel: UILabel!
    @IBOutlet weak var endAddressTextField: ThemTextField!
    @IBOutlet weak var startDateTitleLabel: UILabel!
    @IBOutlet weak var startDateTextField: ThemTextField!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextView: ThemTextView!
    @IBOutlet weak var noteTextViewHeighConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var confirmTripButton: UIButton!
    
    var gradientLayer: CAGradientLayer!
    
    let timePicker:UIDatePicker = UIDatePicker()
    var addressArray = [[String: AnyObject]]()
    
    var isNoteFilled = false
    let textViewPlaceholder = L("carrier.ui.placeholder.note")
    let textFieldFont = UIFont.systemFont(ofSize: 16)
    let noteTextViewHeigh: CGFloat = 32
    let textViewEstimateY: CGFloat = 240
    
    //MARK: - 选择的国家索引
    var startCountryIndex = 0
    var startStateIndex = 0
    var startCitiesIndex = 0
    
    var endCountryIndex = 0
    var endStateIndex = 0
    var endCitiesIndex = 0
    
    var indexOfTextField : Int = 0
    var pickUpDate :Double = 0
    var endCity: String = ""
    var endState: String  = ""
    var endCountry: String = ""
    var startCity: String = ""
    var startState: String = ""
    var startCountry: String = ""
    
    var isPostingTrip = false
    
    lazy var pickerView : UIPickerView = {
        let p = UIPickerView()
        p.dataSource = self
        p.delegate = self
        p.isHidden = false
        p.tag = 3
        return p
    }()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.shared.startTimeTrackingKey(.carrierDetailFillTime)
        setupNavigationBar()
        setupScrollView()
        setupTextFields()
        setupcomfirmTripButton()
        setUpAddressPicker()
        setupTimePicker()
        judgeButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackgroundColor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == segueIdTripComplete) {
            if let viewController = segue.destination as? TripCompletedController, let trip = sender as? Trip {
                viewController.trip = trip
            }
        }
    }
    
    private func setupNavigationBar(){
        title = L("carrier.ui.title.trip")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupScrollView(){
        scrollView.layer.cornerRadius = 10
        scrollView.layer.masksToBounds = true
        let font = UIFont.systemFont(ofSize: 20)
        startAddressTitleLabel.font = font
        endAddressTitleLabel.font = font
        startDateTitleLabel.font = font
        noteTitleLabel.font = font
        startAddressTitleLabel.text = L("carrier.ui.title.startAddress")
        endAddressTitleLabel.text = L("carrier.ui.title.endAddress")
        startDateTitleLabel.text = L("carrier.ui.title.startDate")
        noteTitleLabel.text = L("carrier.ui.title.note")

    }

    private func setupTextFields(){
        textFieldAddToolBar(startAddressTextField, nil)
        textFieldAddToolBar(endAddressTextField, nil)
        textFieldAddToolBar(startDateTextField, nil)
        textFieldAddToolBar(nil, noteTextView)
        noteTextViewHeighConstraint.constant = noteTextViewHeigh
    }
    
    private func setupcomfirmTripButton(){
        confirmTripButton.setTitle(L("carrier.ui.title.post-trip"), for: .normal)
        confirmTripButton.isEnabled = false
    }
    
    private func setUpAddressPicker(){
        let path = Bundle.main.path(forResource: "address", ofType:"plist")
        self.addressArray = NSArray(contentsOfFile: path!) as! Array
    }

    private func setupTimePicker(){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = L("carrier.ui.formatter.date") //"yyyy年MM月dd日"
        let currentDateStr = timeFormatter.string(from: date) as String
        if let maxDate: Date = Date.getFutureDateFromNow(year: 2) {
            timePicker.maximumDate = maxDate
        }
        timePicker.datePickerMode = UIDatePickerMode.date
        timePicker.backgroundColor = .white
        timePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        startDateTextField.text = currentDateStr
        pickUpDate = date.timeIntervalSince1970
    }

    
    private func setupBackgroundColor(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let beginColor :UIColor = UIColor.MyTheme.nightA
        let endColor :UIColor = UIColor.MyTheme.nightB
        gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func commitTripInfo(_ sender: Any) {
        if self.pickUpDate < (Date().timeIntervalSince1970 - 86400) {    //86400 seconds/day
            self.displayAlert(title: L("carrier.error.title.date"), message: L("carrier.error.message.date"), action: L("action.ok"))
            return
        }
        
        if isPostingTrip {
            return
        }
        
        AnalyticsManager.shared.finishTimeTrackingKey(.carrierDetailFillTime)
        
        let days = Date(timeIntervalSince1970: pickUpDate).days(from: Date())
        AnalyticsManager.shared.track(.carrierPrePublishDay, attributes: ["days": days])
        
        let trip = Trip()
        trip.endAddress?.state = endState
        trip.endAddress?.city = endCity
        trip.endAddress?.country = Country(rawValue: endCountry)
        trip.startAddress?.state = startState
        trip.startAddress?.city = startCity
        trip.startAddress?.country = Country(rawValue: startCountry)
        trip.pickupDate = pickUpDate
        trip.note = isNoteFilled ? noteTextView.text : ""
    
        isPostingTrip = true
        
        ApiServers.shared.postTripInfo(trip: trip) { (success, msg, tripCode) in
            
            self.isPostingTrip = false
            
            if success, let tripCode = tripCode {
                trip.tripCode = tripCode
                self.performSegue(withIdentifier: self.segueIdTripComplete, sender: trip)
                ProfileManager.shared.loadLocalUser(completion: nil)
                TripOrderDataStore.shared.pull(category: .carrier, delay: 1, completion: nil)
            } else {
                self.displayGlobalAlert(title: L("carrier.error.title.post"), message: L("carrier.error.message.post"), action: L("action.ok"), completion: nil)
                self.judgeButtonState()
                DLog(msg ?? "Failed post trip")
            }
        }
    }
    
    private func setupBackGroundColor(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        let beginColor :UIColor = UIColor.MyTheme.nightA
        let endColor :UIColor = UIColor.MyTheme.nightB
        gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        judgeButtonState()
    }
}

// MARK: - TextField Delegate
extension TripController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == startAddressTextField {
            indexOfTextField = 0
            pickerView.selectRow(startCountryIndex, inComponent: 0, animated: false)
            pickerView.selectRow(startStateIndex, inComponent: 1, animated: false)
            pickerView.selectRow(startCitiesIndex, inComponent: 2, animated: false)
            textField.inputView = pickerView
            
        }else if textField == endAddressTextField {
            indexOfTextField = 1
            pickerView.selectRow(endCountryIndex, inComponent: 0, animated: false)
            pickerView.selectRow(endStateIndex, inComponent: 1, animated: false)
            pickerView.selectRow(endCitiesIndex, inComponent: 2, animated: false)
            textField.inputView = pickerView

        }else if textField == startDateTextField {
            indexOfTextField = 2
            textField.inputView = timePicker

        }
    }
    
    fileprivate func textFieldAddToolBar(_ textField: UITextField?, _ textView: UITextView?) {
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
        
        if let tf = textField {
            tf.font = textFieldFont
            tf.delegate = self
            tf.inputAccessoryView = bar
        }
        if let tv = textView {
            tv.font = textFieldFont
            tv.delegate = self
            tv.inputAccessoryView = bar
            tv.textColor = colorTextViewPlaceholderGray
            tv.text = textViewPlaceholder
        }
    }
    func textFieldDoneButtonTapped(){
        dismissKeyboard()
        switch indexOfTextField {
        case 0:
            let location = locationTuples(countryIdx: startCountryIndex, stateIdx: startStateIndex, cityIdx: startCitiesIndex)
            startCountry = location.0
            startState = location.1
            startCity = (location.2).isEmpty ? "" : location.2
            self.startAddressTextField.text = startCountry + " " + startState + " " + startCity
            
        case 1:
            let location = locationTuples(countryIdx: endCountryIndex, stateIdx: endStateIndex, cityIdx: endCitiesIndex)
            endCountry = location.0
            endState = location.1
            endCity = (location.2).isEmpty ? "" : location.2
            self.endAddressTextField.text = endCountry + " " + endState + " " + endCity
            
        default:
            DLog("no picker")
        }
        dismissKeyboard()
        judgeButtonState()
    }
    
    func textFieldCancelButtonTapped(){
        dismissKeyboard()
    }
    
    fileprivate func dismissKeyboard(){
        startAddressTextField.resignFirstResponder()
        endAddressTextField.resignFirstResponder()
        startDateTextField.resignFirstResponder()
        noteTextView.resignFirstResponder()
    }
    
}

// MARK: - TextView Delegate
extension TripController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        indexOfTextField = 3
        textView.text = isNoteFilled ? textView.text : ""
        textView.textColor = colorTextBlack
        textViewAnimateUp(textView, toY: textViewEstimateY, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isNoteFilled = !textView.text.isEmpty
        textView.text = isNoteFilled ? textView.text : textViewPlaceholder
        textView.textColor = isNoteFilled ? colorTextBlack : colorTextFieldPlaceholderBlack
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let t = textView.text, t.count > 15 else { return }
        let sz = CGSize(width: textView.bounds.width, height: 100)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let atts = [NSFontAttributeName: textFieldFont]
        let estimateRect = NSString(string: t).boundingRect(with: sz, options: option, attributes: atts, context: nil)
        noteTextViewHeighConstraint.constant = max(noteTextViewHeigh, estimateRect.height + 10)
        self.view.layoutIfNeeded()
        self.textViewAnimateUp(textView, toY: textViewEstimateY, animated: false)
        
        let noteText = textView.text ?? ""
        isNoteFilled = !noteText.isEmpty
    }
    
    private func textViewAnimateUp(_ textView: UITextView, toY yLoc: CGFloat, animated anm: Bool) {
        let textViewLoc = textView.convert(CGPoint(x: 0, y: 0), to: view)
        if textViewLoc.y - view.frame.height < yLoc {
            scrollView.setContentOffset(CGPoint(x: 0, y: yLoc), animated: anm)
        }
    }
    
}


// MARK: - PickerView DataSource
extension TripController: UIPickerViewDataSource {
    //设置选择框的行数，继承于UIPickerViewDataSource协议
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let countryIndex = (indexOfTextField == 0) ? startCountryIndex : endCountryIndex
        let stateIndex = (indexOfTextField == 0) ? startStateIndex : endStateIndex
        
        if component == 0 {
            return self.addressArray.count
            
        } else if component == 1 {
            if let statesArray = self.countryDictionary(countryIdx: countryIndex)?["states"] as? [[String: Any]] {
                return statesArray.count
            }
            return 0
            
        } else {
            if let cityArray = self.stateDictionary(countryIdx: countryIndex, stateIdx: stateIndex)?["cities"] as? [[String: Any]] {
                return cityArray.count
            }
            return 0
        }
    }
    
}

// MARK: - PickerView Delegate
extension TripController: UIPickerViewDelegate {
    
    //MARK: Plist data processors
    func locationTuples(countryIdx: Int, stateIdx: Int, cityIdx: Int) -> (String, String, String) {
        let country = countryDictionary(countryIdx: countryIdx)
        let state = stateDictionary(countryIdx: countryIdx, stateIdx: stateIdx)
        let city = cityDictionary(countryIdx: countryIdx, stateIdx: stateIdx, cityIdx: cityIdx)
        
        let countryStr = (country?["country"] as? String) ?? ""
        let stateStr = (state?["state"] as? String) ?? ""
        let cityStr = (city?["city"] as? String) ?? ""
        
        return (countryStr, stateStr, cityStr)
    }
    
    func countryDictionary(countryIdx: Int) -> [String: Any]? {
        if countryIdx < self.addressArray.count {
            return self.addressArray[countryIdx]
        }
        return nil
    }
    
    func stateDictionary(countryIdx: Int, stateIdx: Int) -> [String: Any]? {
        if let country = countryDictionary(countryIdx: countryIdx), let states = country["states"] as? [[String: Any]?] {
            if states.count > stateIdx {
                return states[stateIdx]
            }
            return nil
        }
        return nil
    }
    
    func cityDictionary(countryIdx: Int, stateIdx: Int, cityIdx: Int) -> [String: Any]? {
        if let state = stateDictionary(countryIdx: countryIdx, stateIdx: stateIdx), let cities = state["cities"] as? [[String: Any]?] {
            if cities.count > cityIdx {
                return cities[cityIdx]
            }
            return nil
        }
        return nil
    }
    
    
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let countryIndex = (indexOfTextField == 0) ? startCountryIndex : endCountryIndex
        let stateIndex = (indexOfTextField == 0) ? startStateIndex : endStateIndex
        
        if component == 0 {
            if let countryName = countryDictionary(countryIdx: row)?["country"] as? String {
                return countryName
            }
            return ""
            
        } else if component == 1 {
            if let stateName = stateDictionary(countryIdx: countryIndex, stateIdx: row)?["state"] as? String {
                return stateName
            }
            return ""
            
        } else {
            if let cityName = cityDictionary(countryIdx: countryIndex, stateIdx: stateIndex, cityIdx: row)?["city"] as? String {
                return cityName
            }
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //根据列、行索引判断需要改变数据的区域
        switch (component) {
        case 0:
            if indexOfTextField == 0 {
                startCountryIndex = row
                startStateIndex = 0
                startCitiesIndex = 0
            } else {
                endCountryIndex = row
                endStateIndex = 0
                endCitiesIndex = 0
            }
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: false)
            pickerView.selectRow(0, inComponent: 2, animated: false)
            
        case 1:
            if indexOfTextField == 0 {
                startStateIndex = row
                startCitiesIndex = 0
            } else {
                endStateIndex = row
                endCitiesIndex = 0
            }
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: false)
            
        case 2:
            if indexOfTextField == 0 {
                startCitiesIndex = row
            } else {
                endCitiesIndex = row
            }
        default:
            break;
        }
    }
    
    //设置选择框的列数为3列,继承于UIPickerViewDataSource协议
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    @objc fileprivate func datePickerValueChanged(){
        let getDate = timePicker.date
        guard getDate.days(from: Date()) >= 0 else {
            timePicker.setDate(Date(), animated: true)
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = L("carrier.ui.formatter.date") // "yyyy年MM月dd日"
        let dateText = formatter.string(from: getDate)
        startDateTextField.text = dateText
        pickUpDate = getDate.timeIntervalSince1970
    }
    
    fileprivate func judgeButtonState(){
        let isOk = (!(startAddressTextField.text?.isEmpty ?? true) &&
            !(endAddressTextField.text?.isEmpty ?? true) &&
            !(startDateTextField.text?.isEmpty ?? true))

        confirmTripButton.backgroundColor = isOk ? colorTheamRed : colorButtonGray
        confirmTripButton.setTitleColor((isOk ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), for: .normal)
        confirmTripButton.backgroundColor = isOk ? colorTheamRed : #colorLiteral(red: 0.8972528577, green: 0.9214243889, blue: 0.9380477071, alpha: 1)
        confirmTripButton.isEnabled = isOk
    }
    
}

