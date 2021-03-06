//
//  ShipperAvailableController.swift
//  carryonex
//
//  Created by Xin Zou on 8/26/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import FSCalendar


class ShipperAvailableController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UIGestureRecognizerDelegate {
    
    var request : Request!
    
    var calendarView : FSCalendar!
    var calendarHeightConstraint: NSLayoutConstraint!
    
    var timeOffsetsAM : [Int] = []
    var timeOffsetsPM : [Int] = []
    
    var isAMSelected = true
    
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
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
    
    let scrollView : UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = .white
        return v
    }()

    let hintLabel : UILabel = {
        let b = UILabel()
        b.backgroundColor = .white
        b.textColor = .orange
        b.text = "请选择以下揽件人空闲时间，上门取货"
        b.textAlignment = .center
        b.font = UIFont.systemFont(ofSize: 12)
        return b
    }()
    
    let labelAM : UILabel = {
        let b = UILabel()
        b.text = "上午"
        b.textAlignment = .center
        b.font = UIFont.boldSystemFont(ofSize: 16) // selected will larger
        b.backgroundColor = .white
        return b
    }()
    let labelPM : UILabel = {
        let b = UILabel()
        b.text = "下午"
        b.textAlignment = .center
        b.font = UIFont.systemFont(ofSize: 14)
        b.backgroundColor = .white
        return b
    }()
    lazy var buttonAMPM : UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(buttonAMPMTapped), for: .touchUpInside)
        b.backgroundColor = .clear
        return b
    }()
    let underlineView : UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    
    let timeCellId = "timeCellId"
    
    let collectionViewSideMargin: CGFloat = 30
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 160, 0) //page insets: (top, left, bot, right)
//        layout.invalidateLayout() // do we need this ???
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.dataSource = self
        c.delegate = self
        c.backgroundColor = .white
        c.isPagingEnabled = false
        c.isUserInteractionEnabled = true
        return c
    }()
    
    let buttonHeight : CGFloat = 40
    
    lazy var finishButton : UIButton = {
        let b = UIButton()
        b.setupAppearance(backgroundColor: buttonThemeColor, title: "确认取货时间", textColor: .white, fontSize: 16)
        b.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTimeSliceData()
        
        setupNavigationBar()
        
        setupScrollView() // container for calendar, hintLabel, collectionView
        
        setupFinishButton()
        
        /// calendar animation
        self.view.addGestureRecognizer(scopeGesture)
        self.collectionView.addGestureRecognizer(scopeGesture)
//        self.collectionView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
    }
    
    
    private func setupTimeSliceData(){
        
        for delta in stride(from: 3600 * 9, to: 3600 * 20, by: 60 * 15) { // 00:00-->24:00, def = 15 min
            if delta <= 3600 * 12 { // AM
                timeOffsetsAM.append(delta)
            }else{ // PM
                timeOffsetsPM.append(delta)
            }
        }

    }
    
    private func setupNavigationBar(){
        navigationItem.title = "取货时间"
        
        let rightBtn = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(finishButtonTapped))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    private func setupScrollView(){
        view.addSubview(scrollView)
        scrollView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: buttonHeight, width: 0, height: 0)
        
        setupCalendar()
        
        setupHintLabel()
        
        setupButtonAndLabelsUnderline()
        
        setupCollectionView()
        
    }
    
    private func setupCalendar(){
        calendarView = FSCalendar()
        
        let sideMargin: CGFloat = 20
        let calendarHeight: CGFloat = UIScreen.main.bounds.height / 2.0 - 60
        
        scrollView.addSubview(calendarView)
        calendarView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: sideMargin, topConstent: 0, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 0) // height = 300
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
        calendarView.appearance.todaySelectionColor = buttonThemeColor
        calendarView.appearance.selectionColor = buttonThemeColor
        calendarView.scope = .week
        
    }

    private func setupHintLabel(){
        scrollView.addSubview(hintLabel)
        hintLabel.addConstraints(left: view.leftAnchor, top: calendarView.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 20)
    }
    private func setupButtonAndLabelsUnderline(){
        let labelWidth : CGFloat = 66
        let labelHeigh : CGFloat = 30
        let topMargin  : CGFloat = 0
        scrollView.addSubview(labelAM)
        labelAM.addConstraints(left: nil, top: hintLabel.bottomAnchor, right: view.centerXAnchor, bottom: nil, leftConstent: 0, topConstent: topMargin, rightConstent: 0, bottomConstent: 0, width: labelWidth, height: labelHeigh)
        
        scrollView.addSubview(labelPM)
        labelPM.addConstraints(left: view.centerXAnchor, top: hintLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: topMargin, rightConstent: 0, bottomConstent: 0, width: labelWidth, height: labelHeigh)
        
        scrollView.addSubview(buttonAMPM)
        buttonAMPM.addConstraints(left: nil, top: hintLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: labelWidth * 3, height: labelHeigh + 20) // labelHeigh + offset for larger tapping area;
        buttonAMPM.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonAMPM.centerYAnchor.constraint(equalTo: labelAM.centerYAnchor).isActive = true
        
        scrollView.addSubview(underlineView)
        underlineView.addConstraints(left: nil, top: buttonAMPM.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: labelWidth * 2, height: 2)
        underlineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func setupCollectionView(){
        view.addSubview(collectionView)
//        collectionView.addConstraints(left: scrollView.leftAnchor, top: underlineView.bottomAnchor, right: scrollView.rightAnchor, bottom: nil, leftConstent: collectionViewSideMargin, topConstent: 10, rightConstent: collectionViewSideMargin, bottomConstent: 0, width: 0, height: 200)
        collectionView.addConstraints(left: scrollView.leftAnchor, top: underlineView.bottomAnchor, right: scrollView.rightAnchor, bottom: view.bottomAnchor, leftConstent: collectionViewSideMargin, topConstent: 10, rightConstent: collectionViewSideMargin, bottomConstent: 60, width: 0, height: 0)
        
        collectionView.register(ShipperAvailableCell.self, forCellWithReuseIdentifier: timeCellId)
        //collectionView.isUserInteractionEnabled = false // can NOT use this to lock scroll animation
        collectionView.allowsMultipleSelection = false
        collectionView.isPagingEnabled = true
        //already setted layout.scrollDirection = .horizontal
    }
    
    private func setupFinishButton(){
        view.addSubview(finishButton)
        finishButton.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: buttonHeight)
    }
    
    
    
    
}


