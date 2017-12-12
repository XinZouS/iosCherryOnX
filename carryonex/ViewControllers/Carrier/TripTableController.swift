//
//  TripTableController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/28.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class TripTableController: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate,UITextViewDelegate{
    
    @IBOutlet weak var tripTableView: UITableView!
    @IBOutlet weak var otherTextField: UITextView!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var endLocation: UITextField!
    @IBOutlet weak var beginLocation: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    
    let timePicker:UIDatePicker = UIDatePicker()
    var addressArray = [[String: AnyObject]]()
    
    //选择的国家索引
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
    
    lazy var pickerView : UIPickerView = {
        let p = UIPickerView()
        p.dataSource = self
        p.delegate = self
        p.isHidden = false
        p.tag = 3
        return p
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonOnKeyboard()
        tripTableView.allowsSelection = false
        setUpPicker()
        otherTextField.delegate = self
    }
    
    private func setUpPicker(){
        let path = Bundle.main.path(forResource: "address", ofType:"plist")
        self.addressArray = NSArray(contentsOfFile: path!) as! Array
    }
    
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0,y:0,width:320,height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [flexSpace,done]
        doneToolbar.sizeToFit()
        self.beginLocation.inputAccessoryView = doneToolbar
        self.endLocation.inputAccessoryView = doneToolbar
        self.timeTextField.inputAccessoryView = doneToolbar
        self.otherTextField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        if otherTextField.text == ""{
            self.hintLabel.isHidden = false
        }
        self.timeTextField.resignFirstResponder()
        self.otherTextField.resignFirstResponder()
        self.beginLocation.resignFirstResponder()
        self.endLocation.resignFirstResponder()
        switch indexOfTextField {
        case 0:
            let location = locationTuples(countryIdx: startCountryIndex, stateIdx: startStateIndex, cityIdx: startCitiesIndex)
            startCountry = location.0
            startState = location.1
            startCity = location.2
            self.beginLocation.text = startCountry + " " + startState + " " + startCity
        case 1:
            let location = locationTuples(countryIdx: endCountryIndex, stateIdx: endStateIndex, cityIdx: endCitiesIndex)
            endCountry = location.0
            endState = location.1
            endCity = location.2
            self.endLocation.text = endCountry + " " + endState + " " + endCity
        default:
            print("no picker")
        }
        judgeButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTimePicker()
    }
    
    private func setupTimePicker(){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let strNowTime = timeFormatter.string(from: date) as String
        let calendar = Calendar.current
        var maxComponents = calendar.dateComponents([.day,.month,.year], from: Date())
        let YearStartIndex = strNowTime.index(strNowTime.startIndex, offsetBy: 0)
        let YearEndIndex = strNowTime.index(strNowTime.startIndex, offsetBy: 3)
        let MonthStartIndex = strNowTime.index(strNowTime.startIndex, offsetBy: 4)
        let MonthendIndex = strNowTime.index(strNowTime.startIndex, offsetBy: 5)
        let DayStartIndex = strNowTime.index(strNowTime.startIndex, offsetBy: 6)
        let DayendIndex = strNowTime.index(strNowTime.startIndex, offsetBy: 7)
        let nowYear = Int(strNowTime[YearStartIndex...YearEndIndex])
        let nowMonth = Int(strNowTime[MonthStartIndex...MonthendIndex])
        let nowDay = Int(strNowTime[DayStartIndex...DayendIndex])
        maxComponents.day = nowDay
        maxComponents.month = nowMonth
        maxComponents.year = nowYear! + 2   //Give a bit of breathing room
        if let maxDate: Date = calendar.date(from: maxComponents) {
            timePicker.maximumDate = maxDate
        }
        timePicker.datePickerMode = UIDatePickerMode.date
        timePicker.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        timePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        timeTextField.text = strNowTime[YearStartIndex...YearEndIndex] + "年"                            + strNowTime[MonthStartIndex...MonthendIndex] + "月" + strNowTime[DayStartIndex...DayendIndex] + "日"
        pickUpDate = date.timeIntervalSince1970
    }
    
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
    
    //选中项改变事件（将在滑动停止后触发）
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
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
    
    @IBAction func beginLcationTapped(_ sender: Any) {
        indexOfTextField = 0
        pickerView.selectRow(startCountryIndex, inComponent: 0, animated: false)
        pickerView.selectRow(startStateIndex, inComponent: 1, animated: false)
        pickerView.selectRow(startCitiesIndex, inComponent: 2, animated: false)
        beginLocation.inputView = pickerView
    }

    @IBAction func endLocationTapped(_ sender: Any) {
        indexOfTextField = 1
        pickerView.selectRow(endCountryIndex, inComponent: 0, animated: false)
        pickerView.selectRow(endStateIndex, inComponent: 1, animated: false)
        pickerView.selectRow(endCitiesIndex, inComponent: 2, animated: false)
        endLocation.inputView = pickerView
    }
    
    @IBAction func timeTextFieldTapped(_ sender: Any) {
        //        transparentView.isHidden = false
        indexOfTextField = 2
        var offset = tripTableView.contentOffset
        offset.y = tripTableView.contentSize.height + tripTableView.contentInset.bottom - tripTableView.bounds.size.height
        tripTableView.setContentOffset(offset, animated: true)
        timeTextField.inputView = timePicker
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        hintLabel.isHidden = true
        indexOfTextField = 3
        judgeButtonState()
        var offset = tripTableView.contentOffset
        offset.y = tripTableView.contentSize.height + tripTableView.contentInset.bottom - tripTableView.bounds.size.height
        tripTableView.setContentOffset(offset, animated: true)
    }

    @IBAction func tobeginTextField(_ sender: Any) {
        beginLocation.becomeFirstResponder()
    }
    
    @IBAction func toEndTextField(_ sender: Any) {
        endLocation.becomeFirstResponder()
    }
    
    @IBAction func toTimeTextField(_ sender: Any) {
        timeTextField.becomeFirstResponder()
    }
    
    @objc private func datePickerValueChanged(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let date = timePicker.date
        let dateText = formatter.string(from: date)
        timeTextField.text = dateText
        pickUpDate = date.timeIntervalSince1970
    }
    
    private func judgeButtonState(){
        if (beginLocation.text != "" && (endLocation.text != "" && timeTextField.text != "")){
            if let parentVC = self.parent as? TripController{
                parentVC.confirmTripButton.backgroundColor = #colorLiteral(red: 1, green: 0.4189302325, blue: 0.4186580479, alpha: 1)
                parentVC.confirmTripButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                parentVC.confirmTripButton.isEnabled = true
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 10, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Verdana", size: 20)
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(30)
    }
    
    //MARK: Plist data processors
    func locationTuples(countryIdx: Int, stateIdx: Int, cityIdx: Int) -> (String, String, String) {
        let country = countryDictionary(countryIdx: countryIdx)
        let state = stateDictionary(countryIdx: countryIdx, stateIdx: stateIdx)
        let city = cityDictionary(countryIdx: countryIdx, stateIdx: stateIdx, cityIdx: cityIdx)
        
        let countryStr = country!["country"] as! String
        let stateStr = state!["state"] as! String
        let cityStr = city!["city"] as! String
        
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
    
}
