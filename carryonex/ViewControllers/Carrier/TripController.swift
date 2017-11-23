//
//  TripController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/19.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit
import FSCalendar

class TripController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate{
    @IBOutlet weak var confirmTripButton: UIButton!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var tripScrollView: UIScrollView!
    let timePicker:UIDatePicker = UIDatePicker()
    var addressArray = [[String: AnyObject]]()
    //选择的国家索引
    var countryIndex = 0
    //选择的省索引
    var stateIndex = 0
    //选择城市索引
    var citiesIndex = 0
    var indexOfTextField : Int = 0
    var areaPickerMenu : UIPickerMenuView?
    var pickUpDate :Double = 0
    var endCity: String = ""
    var endState: String  = ""
    var endCountry: String = ""
    var startCity: String = ""
    var startState: String = ""
    var startCountry: String = ""
    var gradientLayer: CAGradientLayer!
    
    lazy var pickerView : UIPickerView = {
        let p = UIPickerView()
        p.dataSource = self
        p.delegate = self
        p.isHidden = false
        p.tag = 3
        return p
    }()
    
    lazy var areaMenuOKButton : UIButton = {
        let b = UIButton()
        let attributes:[String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16),
            NSForegroundColorAttributeName: textThemeColor]
        let attribStr = NSAttributedString(string: "确定", attributes: attributes)
        b.setAttributedTitle(attribStr, for: .normal)
        b.addTarget(self, action: #selector(areaMenuOKButtonTapped), for: .touchUpInside)
        return b
    }()
    lazy var areaPickerCancelButton: UIButton = {
        let b = UIButton()
        let attributes:[String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16),
            NSForegroundColorAttributeName: UIColor.gray]
        b.backgroundColor = .clear
        return b
    }()
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var endLocation: UITextField!
    @IBOutlet weak var beginLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupcomfirmTripButton()
        let path = Bundle.main.path(forResource: "address", ofType:"plist")
        self.addressArray = NSArray(contentsOfFile: path!) as! Array
        setUpPicker()
        self.addDoneButtonOnKeyboard()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupNavigationBar()
    }
    
    private func setupNavigationBar(){
        title = "出行"
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0,y:0,width:320,height:50))
            doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
            doneToolbar.items = [flexSpace,done]
            doneToolbar.sizeToFit()
        self.timeTextField.inputAccessoryView = doneToolbar
        self.otherTextField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.timeTextField.resignFirstResponder()
        self.otherTextField.resignFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupBackgroundColor()
        setupTimePicker()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tripComplete") {
            if let destVC = segue.destination as? TripCompletedController{
                destVC.beginLocationString = beginLocation.text
                destVC.endLocationString = endLocation.text
                destVC.dateString = timeTextField.text
                destVC.descriptionString = otherTextField.text
                if let tripId = sender {
                    destVC.tripId = tripId as! Int
                }
            }
        }
    }
    
    private func setupTimePicker(){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let strNowTime = timeFormatter.string(from: date) as String
        let calendar = Calendar.current
        var minComponents = calendar.dateComponents([.day,.month,.year], from: Date())
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
        maxComponents.year = nowYear!+1
        minComponents.day = nowDay
        minComponents.month = nowMonth
        minComponents.year = nowYear
        let minDate: Date = calendar.date(from: minComponents)!
        let maxDate: Date = calendar.date(from: maxComponents)!
        timePicker.datePickerMode = UIDatePickerMode.date
        timePicker.minimumDate = minDate
        timePicker.maximumDate = maxDate
        timePicker.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        timePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        timeTextField.text = strNowTime[YearStartIndex...YearEndIndex]+"年"+strNowTime[MonthStartIndex...MonthendIndex]+"月"+strNowTime[DayStartIndex...DayendIndex]+"日"
        pickUpDate = date.timeIntervalSince1970
    }
    
    func areaMenuOKButtonTapped(){
            let country = self.addressArray[countryIndex]
            let state = (country["states"] as! NSArray)[stateIndex]
                as! [String: AnyObject]
            let city = (state["cities"] as! NSArray)[citiesIndex]
                as! [String: AnyObject]
        if let countryStr = self.addressArray[countryIndex]["country"] as? String,let stateStr = state["state"] as? String,let cityStr = city["city"] as? String {
            if indexOfTextField == 0 {
                startState = stateStr
                startCity = cityStr
                startCountry = countryStr
                beginLocation.text = countryStr + " " + stateStr + " " + cityStr
            }else{
                endState = stateStr
                endCity = cityStr
                endCountry = countryStr
                endLocation.text = countryStr + " " + stateStr + " " + cityStr
            }
        }
        textFieldsInAllCellResignFirstResponder()
        areaPickerMenu?.dismissAnimation()
    }
    func setUpPicker(){
        areaPickerMenu = UIPickerMenuView(frame: .zero)
        areaPickerMenu?.setupMenuWith(hostView: self.view, targetPickerView: pickerView, leftBtn: areaPickerCancelButton, rightBtn: areaMenuOKButton)
        view.addSubview(areaPickerMenu!)
    }
    private func setupcomfirmTripButton(){
        confirmTripButton.isEnabled = false
        confirmTripButton.backgroundColor = #colorLiteral(red: 0.8972528577, green: 0.9214243889, blue: 0.9380477071, alpha: 1)
        confirmTripButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
    }
    
    private func setupBackgroundColor(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let beginColor :UIColor = UIColor.MyTheme.darkBlue
        let endColor :UIColor = UIColor.MyTheme.cyan
        gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    //设置选择框的行数，继承于UIPickerViewDataSource协议
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return self.addressArray.count
            } else if component == 1 {
                let country = self.addressArray[countryIndex]
                return country["states"]!.count
            } else {
                let country = self.addressArray[countryIndex]
                if let state = (country["states"] as! NSArray)[stateIndex]
                    as? [String: AnyObject] {
                    return state["cities"]!.count
                } else {
                    return 0
                }
            }
    }
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
            if component == 0 {
                return self.addressArray[row]["country"] as? String
            }else if component == 1 {
                let country = self.addressArray[countryIndex]
                let state = (country["states"] as! NSArray)[row]
                    as! [String: AnyObject]
                return state["state"] as? String
            }else {
                let country = self.addressArray[countryIndex]
                let state = (country["states"] as! NSArray)[stateIndex]
                    as! [String: AnyObject]
                let city = (state["cities"] as! NSArray)[row]
                    as! [String: AnyObject]
                return city["city"] as? String
            }
    }
    //选中项改变事件（将在滑动停止后触发）
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        //根据列、行索引判断需要改变数据的区域
            switch (component) {
            case 0:
                countryIndex = row;
                stateIndex = 0;
                pickerView.reloadComponent(1);
                pickerView.reloadComponent(2);
                pickerView.selectRow(0, inComponent: 1, animated: false)
                pickerView.selectRow(0, inComponent: 2, animated: false)
            case 1:
                stateIndex = row;
                pickerView.reloadComponent(2);
                pickerView.selectRow(0, inComponent: 2, animated: false)
            case 2:
                citiesIndex = row;
            default:
                break;
            }
    }
    //设置选择框的列数为3列,继承于UIPickerViewDataSource协议
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 3
    }
    @IBAction func beginLocationTapped(_ sender: Any) {
        indexOfTextField = 0
        beginLocation.inputView = areaPickerMenu
        areaPickerMenu?.showUpAnimation(withTitle: "选择地区")
    }
    @IBAction func timeTextFieldTapped(_ sender: Any) {
//        transparentView.isHidden = false
        var offset = tripScrollView.contentOffset
        offset.y = tripScrollView.contentSize.height + tripScrollView.contentInset.bottom - tripScrollView.bounds.size.height
        tripScrollView.setContentOffset(offset, animated: true)
        timeTextField.inputView = timePicker
        
    }
    
    @IBAction func endLocationTapped(_ sender: Any) {
        indexOfTextField = 1
        endLocation.inputView = areaPickerMenu
        areaPickerMenu?.showUpAnimation(withTitle: "选择地区")
    }
    
    @IBAction func otherTextFieldTapped(_ sender: Any) {
        var offset = tripScrollView.contentOffset
        offset.y = tripScrollView.contentSize.height + tripScrollView.contentInset.bottom - tripScrollView.bounds.size.height
        tripScrollView.setContentOffset(offset, animated: true)
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
    
    @IBAction func commitTripInfo(_ sender: Any) {
        let trip = Trip()
        trip.endAddress?.state = endState
        trip.endAddress?.city = endCity
        trip.endAddress?.country = Country(rawValue:endCountry)
        trip.startAddress?.state = startState
        trip.startAddress?.city = startCity
        trip.startAddress?.country = Country(rawValue: startCountry)
        trip.pickupDate = pickUpDate
        ApiServers.shared.postTripInfo(trip: trip) { (success,msg, tripId) in
            if success{
                self.performSegue(withIdentifier: "tripComplete", sender: tripId)
            }else{
                print(msg ?? "")
            }
        }
    }
    
    private func setupBackGroundColor(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        let beginColor :UIColor = UIColor.MyTheme.darkBlue
        let endColor :UIColor = UIColor.MyTheme.cyan
        gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
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
            confirmTripButton.backgroundColor = #colorLiteral(red: 1, green: 0.4189302325, blue: 0.4186580479, alpha: 1)
            confirmTripButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            confirmTripButton.isEnabled = true
        }
    }
    func textFieldsInAllCellResignFirstResponder(){
        judgeButtonState()
        beginLocation.resignFirstResponder()
        endLocation.resignFirstResponder()
        timeTextField.resignFirstResponder()
        otherTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if touches.count > 0 {
            textFieldsInAllCellResignFirstResponder()
        }
    }
}
