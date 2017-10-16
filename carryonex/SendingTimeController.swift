//
//  SendingTimeController.swift
//  carryonex
//
//  Created by Xin Zou on 8/24/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import FSCalendar



class SendingTimeController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UIGestureRecognizerDelegate {
    
    let cellId = "SendingTimeTableViewCellId"
    var tableHeadString = "tableTitle"
    
    /** 
     *  one of these group MUST not nil, get Date from them
     */
    weak var requestController : RequestController? { // for setting request
        didSet{
            title = "选择发货时间"
            tableHeadString = "我的发货时间"
        }
    }
    weak var postTripControllerStartTime : PostTripController? { // for setting trip's start time
        didSet{
            guard postTripControllerStartTime != nil else { return }
            title = "旅行出发时间"
            tableHeadString = "我的出发时间"
        }
    }
    weak var postTripControllerPickupTime: PostTripController? { // for setting trip's pickup time
        didSet{
            guard postTripControllerPickupTime != nil else { return }
            title = "设置取货时间"
            tableHeadString = "我的取货时间"
        }
    }
    
    /// MARK: for calendar setup
     
    var calendarView: FSCalendar!
    var calendarHeightConstraint: NSLayoutConstraint!
    
    /// one of them MUST not nil, for data return
    var request : Request?
    var trip : Trip?
    
    /// global Date to save and transfer, if need local display, call getLocalizedDate()
    var currSelectedDate = Date()
    var currDaysInterval : TimeInterval = 0.0
    
    /// Dictionary of all time slices, key:String(yyyyMMdd), value:Date
    internal let timeSlicesAll = [String:[Date]]()
    /// Array of all time sleces in one day
    internal var timeSlicesInDay = [Date]() {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = "yyyy年MM月dd日" // "MM-dd-yyyy" // TODO: for english date
        return formatter
    }()
    lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    
    /// MARK: for datetime result displaying
    
    let tableHeadView : UIView = {
        let v = UIView()
        v.backgroundColor = borderColorLightGray
        return v
    }()
    
    let tableHeadLabel : UILabel = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日" // "MM-dd-yyyy" // TODO: for english date
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 14)
        b.text = "\(formatter.string(from: Date()))"
        b.textColor = .black
        b.textAlignment = .left
        return b
    }()
    
    lazy var addTimeButton : UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Add_Time"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.addTarget(self, action: #selector(addTimeButtonTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var tableView : UITableView = {
        let t = UITableView()
        t.backgroundColor = .white
        t.dataSource = self
        t.delegate = self
        return t
    }()
    
    lazy var okButton : UIButton = {
        let b = UIButton()
        b.setTitle("确认时间", for: .normal)
        b.backgroundColor = buttonThemeColor
        b.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        return b
    }()
    
    
    /// MARK: pickerView: pick starting, ending time
    
    let timePickerBottomMargin:CGFloat = 60

    lazy var backgroundTransparentView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAnimation)))
        return v
    }()
    
    let timePickerMenuView : UIView = {
        let v = UIView()
        v.backgroundColor = pickerColorLightGray
        return v
    }()
    var timePickerMenuTopConstraint : NSLayoutConstraint!
    
    lazy var timePickerView : UIDatePicker = {
        let p = UIDatePicker()
        p.timeZone = TimeZone.current
        p.addTarget(self, action: #selector(timePickerChanged), for: UIControlEvents.valueChanged)
        return p
    }()
    
    var isStartingTime = true // for picking starting time and ending time
    
    let timePickerMenuTitleLabel : UILabel = {
        let b = UILabel()
        b.text = "开始时间"
        b.textAlignment = .center
        b.font = UIFont.systemFont(ofSize: 18)
        return b
    }()
    
    lazy var timePickerButtonCancel : UIButton = {
        let b = UIButton()
        b.setupAppearance(backgroundColor: .clear, title: "取消", textColor: .lightGray, fontSize: 16)
        b.addTarget(self, action: #selector(timePickerCancelButtonTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var timePickerButtonOk : UIButton = {
        let b = UIButton()
        b.setupAppearance(backgroundColor: .clear, title: "下一步", textColor: textThemeColor, fontSize: 16)
        b.addTarget(self, action: #selector(timePickerOkButtonTapped), for: .touchUpInside)
        return b
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupNavigationBar()
        
        setupCalendarView()
        
        setupTableHeadView() // following order should NOT be change
        
        setupOkButton()
        
        setupTableView()
        
        setupTimePickerMenu()
        
        setupGestureRecognizers()
        
    }
    

    
    private func setupNavigationBar(){
        let rightItemButton = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(okButtonTapped))
        navigationItem.rightBarButtonItem = rightItemButton
    }
    
    private func setupCalendarView(){
        calendarView = FSCalendar()
        
        let calendarHeight: CGFloat = UIScreen.main.bounds.height / 2.0 - 60
        
        view.addSubview(calendarView)
        calendarView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 20, topConstent: 0, rightConstent: 20, bottomConstent: 0, width: 0, height: 0) // height = 300
        calendarHeightConstraint = calendarView.heightAnchor.constraint(equalToConstant: calendarHeight)
        calendarHeightConstraint.isActive = true
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.allowsMultipleSelection = false
        calendarView.calendarHeaderView.backgroundColor = .white
        calendarView.calendarWeekdayView.backgroundColor = .white
        calendarView.backgroundColor = .white
        
        //https://github.com/WenchaoD/FSCalendar/blob/master/MOREUSAGE.md
        calendarView.appearance.headerTitleColor = UIColor.black
        calendarView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 14)
        calendarView.appearance.weekdayTextColor = barColorGray
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 12)
        calendarView.appearance.eventDefaultColor = calendarColorLightGray
        calendarView.appearance.eventSelectionColor = buttonThemeColor
        calendarView.appearance.todayColor = barColorGray
        calendarView.appearance.todaySelectionColor = calendarColorLightGray
        calendarView.appearance.selectionColor = buttonThemeColor
        calendarView.scope = postTripControllerStartTime != nil ? .month : .week
        
    }
    
    private func setupTableHeadView(){
        
        view.addSubview(tableHeadView)
        tableHeadView.addConstraints(left: view.leftAnchor, top: calendarView.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 40)
        
        tableHeadView.addSubview(addTimeButton)
        addTimeButton.addConstraints(left: nil, top: tableHeadView.topAnchor, right: tableHeadView.rightAnchor, bottom: tableHeadView.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 25, bottomConstent: 0, width: 20, height: 0)
        
        tableHeadView.addSubview(tableHeadLabel)
        tableHeadLabel.addConstraints(left: tableHeadView.leftAnchor, top: tableHeadView.topAnchor, right: addTimeButton.leftAnchor, bottom: tableHeadView.bottomAnchor, leftConstent: 20, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
    }
    
    private func setupOkButton(){
        view.addSubview(okButton)
        okButton.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 40)
    }

    private func setupTableView(){
        
        tableView.register(SendingTimeTableViewCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        tableView.addConstraints(left: view.leftAnchor, top: tableHeadView.bottomAnchor, right: view.rightAnchor, bottom: okButton.topAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    private func setupTimePickerMenu(){
        let sideMargin: CGFloat = 7
        let buttonWidth:CGFloat = 60
        let buttonHeigh:CGFloat = 40
        
        setupBackgroundTransparentView()
        
        view.addSubview(timePickerMenuView)
        timePickerMenuView.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 300 + timePickerBottomMargin) // showing area height = (height - bottomMargin)
        timePickerMenuTopConstraint = timePickerMenuView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        timePickerMenuTopConstraint.isActive = true
        
        timePickerMenuView.addSubview(timePickerButtonCancel)
        timePickerButtonCancel.addConstraints(left: timePickerMenuView.leftAnchor, top: timePickerMenuView.topAnchor, right: nil, bottom: nil, leftConstent: sideMargin, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: buttonWidth, height: buttonHeigh)
        
        timePickerMenuView.addSubview(timePickerButtonOk)
        timePickerButtonOk.addConstraints(left: nil, top: timePickerMenuView.topAnchor, right: timePickerMenuView.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: sideMargin, bottomConstent: 0, width: buttonWidth, height: buttonHeigh)
        
        timePickerMenuView.addSubview(timePickerMenuTitleLabel)
        timePickerMenuTitleLabel.addConstraints(left: timePickerButtonCancel.rightAnchor, top: timePickerMenuView.topAnchor, right: timePickerButtonOk.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: buttonHeigh)
        
        // setupTimePicker
        
        timePickerView.datePickerMode = .time
        timePickerView.minuteInterval = 10
        timePickerView.backgroundColor = .white
        
        timePickerMenuView.addSubview(timePickerView)
        timePickerView.addConstraints(left: timePickerMenuView.leftAnchor, top: timePickerMenuTitleLabel.bottomAnchor, right: timePickerMenuView.rightAnchor, bottom: timePickerMenuView.bottomAnchor, leftConstent: sideMargin, topConstent: 0, rightConstent: sideMargin, bottomConstent: timePickerBottomMargin, width: 0, height: 0)
    }
    private func setupBackgroundTransparentView(){
        view.addSubview(backgroundTransparentView)
        backgroundTransparentView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        backgroundTransparentView.isHidden = true
    }
    
    private func setupGestureRecognizers(){
        self.view.addGestureRecognizer(scopeGesture)
        self.tableView.addGestureRecognizer(scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
    }
    
}



