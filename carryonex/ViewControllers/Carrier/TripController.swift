//
//  TripController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/19.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit
import CoreLocation
import FSCalendar

class TripController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate{
    @IBOutlet weak var confirmTripButton: UIButton!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var tripScrollView: UIScrollView!
    let timePicker:UIDatePicker = UIDatePicker()
    var locationManager : CLLocationManager!
    var currLocation : CLLocation!
    let address = Address()
    var addressArray = [[String: AnyObject]]()
    //选择的国家索引
    var countryIndex = 0
    //选择的省索引
    var stateIndex = 0
    //选择城市索引
    var citiesIndex = 0
    var indexOfTextField : Int = 0
    var areaPickerMenu : UIPickerMenuView?
//    var transparentView : UIView = {
//        let v = UIView()
//        v.isHidden = true
//        v.backgroundColor = .clear
//        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
//        return v
//    }()
    lazy var pickerView : UIPickerView = {
        let p = UIPickerView()
        p.dataSource = self
        p.delegate = self
        p.isHidden = false
        p.tag = 3 // the id of this picker
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
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupcomfirmTripButton()
        let path = Bundle.main.path(forResource: "address", ofType:"plist")
        self.addressArray = NSArray(contentsOfFile: path!) as! Array
        setUpPicker()
        setupLocation()

//        setUpTransparentView()
        self.addDoneButtonOnKeyboard()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0,y:0,width:320,height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(TripController.doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        self.timeTextField.inputAccessoryView = doneToolbar
        self.otherTextField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.timeTextField.resignFirstResponder()
        self.otherTextField.resignFirstResponder()
    }
//    private func setUpTransparentView(){
//        view.addSubview(transparentView)
//        transparentView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
//    }

    override func viewWillAppear(_ animated: Bool) {
        setupBackgroundColor()
        setupTimePicker()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tripComplete") {
            if let destVC = segue.destination as? tripCompleteController{
                destVC.beginLocationString = beginLocation.text
                destVC.endLocationString = endLocation.text
                destVC.dateString = timeTextField.text
                destVC.descriptionString = otherTextField.text
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
    }
    
    func areaMenuOKButtonTapped(){
            address.country = (self.addressArray[countryIndex]["country"] as? String).map { Country(rawValue: $0) }!
            let country = self.addressArray[countryIndex]
            let state = (country["states"] as! NSArray)[stateIndex]
                as! [String: AnyObject]
            address.state = state["state"] as? String
            let city = (state["cities"] as! NSArray)[citiesIndex]
                as! [String: AnyObject]
            address.city = city["city"] as? String
        if let countryStr = self.addressArray[countryIndex]["country"] as? String,let stateStr = state["state"] as? String,let cityStr = city["city"] as? String {
            if indexOfTextField == 0 {
                beginLocation.text = countryStr + " " + stateStr + " " + cityStr
            }else{
                endLocation.text = countryStr + " " + stateStr + " " + cityStr
            }
        }
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
        judgeButtonState()
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
        judgeButtonState()
    }
    
    @IBAction func otherTextFieldTapped(_ sender: Any) {
        var offset = tripScrollView.contentOffset
        offset.y = tripScrollView.contentSize.height + tripScrollView.contentInset.bottom - tripScrollView.bounds.size.height
        tripScrollView.setContentOffset(offset, animated: true)
        transparentView.isHidden = false
    }
    @objc private func datePickerValueChanged(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let date = timePicker.date
        let dateText = formatter.string(from: date)
        timeTextField.text = dateText
    }
    
//    func textFieldsInAllCellResignFirstResponder(){
//        transparentView.isHidden = true
//        beginLocation.resignFirstResponder()
//        endLocation.resignFirstResponder()
//        timeTextField.resignFirstResponder()
//        otherTextField.resignFirstResponder()
//    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        if touches.count > 0 {
//            textFieldsInAllCellResignFirstResponder()
//        }
//    }
    private func setupLocation(){
        //初始化位置管理器
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //设备使用电池供电时最高的精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
        locationManager.distanceFilter = kCLLocationAccuracyKilometer
        if ios8() {
            //如果是IOS8及以上版本需调用这个方法
            locationManager.requestAlwaysAuthorization()
            //使用应用程序期间允许访问位置数据
            locationManager.requestWhenInUseAuthorization();
            //启动定位
            locationManager.startUpdatingLocation()
        }
    }
    //FIXME: CoreLocationManagerDelegate 中获取到位置信息的处理函数
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //取得locations数组的最后一个
        let location:CLLocation = locations[locations.count-1]
        currLocation = locations.last!
        //判断是否为空
        if(location.horizontalAccuracy > 0){
            let lat = Double(String(format: "%.1f", location.coordinate.latitude))
            let long = Double(String(format: "%.1f", location.coordinate.longitude))
            print("纬度:\(long!)")
            print("经度:\(lat!)")
            LonLatToCity()
            //停止定位
            locationManager.stopUpdatingLocation()
        }
    }
    
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in
            if(error == nil)
            {
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                //城市
                let city: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                //国家
                let country: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as! NSString
                
                let State: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
                self.beginLocation.text = (country as String)+" "+State+" "+city
            }
            else
            {
                print(error ?? "")
            }
        }
    }
    //FIXME:  获取位置信息失败
    private func  locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    func ios8() -> Bool {
        let versionCode:String = UIDevice.current.systemVersion
        let version = NSString(string:  versionCode).doubleValue
        return version >= 8.0
    }
    private func judgeButtonState(){
        if beginLocation.text != nil && endLocation.text != nil && timeTextField.text != nil{
            confirmTripButton.backgroundColor = #colorLiteral(red: 1, green: 0.4189302325, blue: 0.4186580479, alpha: 1)
            confirmTripButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            confirmTripButton.isEnabled = true
        }
    }
}
