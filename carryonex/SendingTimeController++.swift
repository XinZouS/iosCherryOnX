//
//  SendingTimeController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/25/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import FSCalendar



/// MARK: for calendar delegate

extension SendingTimeController {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        currSelectedDate = setTimeForGolbalDate(from: date)
        currDaysInterval = TimeInterval(currSelectedDate.seconds(from: Date()))
        
        let formattedDate = self.dateFormatter.string(from: currSelectedDate)
        tableHeadLabel.text = "\(formattedDate) \(tableHeadString)"
        print("did select date = \(currSelectedDate), formatted = \(formattedDate)")
        
        timeSlicesInDay = [currSelectedDate] // for postTrip begin time only
        
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates are \(selectedDates) \n\r ")
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
    }
    private func setTimeForGolbalDate(from date: Date) -> Date {
        let now = Date()
        var nowComponents = DateComponents()
        let cal = Calendar.current
        nowComponents.year      = cal.component(.year, from: date)
        nowComponents.month     = cal.component(.month, from: date)
        nowComponents.day       = cal.component(.day, from: date)
        nowComponents.hour   = cal.component(.hour, from: now)
        nowComponents.minute = cal.component(.minute, from: now)
        nowComponents.second = cal.component(.second, from: now)
        //nowComponents.timeZone = TimeZone(abbreviation: "GMT")
        return cal.date(from: nowComponents)! as Date
    }
    
    // not allow user to select date ealier than today
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return date.timeIntervalSince1970 > (Date().timeIntervalSince1970 - 3600 * 23)
    }
    
    // UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top

        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendarView.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    

}

/// MARK: tableViewDelegate:

extension SendingTimeController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlicesInDay.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if requestController != nil {
            cell.textLabel?.text = "0:00 AM to 0:00 PM" //"\(request.sendingTime.first)"
        }
        if postTripControllerStartTime != nil {
            cell.textLabel?.text = dateFormatter.string(from: currSelectedDate) + " 出发"
        }
        if postTripControllerPickupTime != nil {
            cell.textLabel?.text = "0:00 AM to 0:00 PM" //"\(request.sendingTime.first)"

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let del = UITableViewRowAction(style: .destructive, title: " 删除 ") { (action, indexpath) in
            print( "TODO: delete item at indexpath")
            
        }
        let edit = UITableViewRowAction(style: .normal, title: " 编辑 ") { (action, indexpath) in
            print( "TODO: edit item at indexpath")
        }
        edit.backgroundColor = buttonThemeColor
        del.backgroundColor = buttonColorRed
        
        
        //return [del, edit] // 出现为：row [ edit | del ]
        return [del]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if postTripControllerStartTime != nil {
            okButtonTapped()
        }
    }
}

// time picker actions:
extension SendingTimeController {
    
    func timePickerChanged(sender: UIDatePicker){
        //let timeIntervalOffset : TimeInterval = timePickerView.date - Date()
        let deltaSecs = timePickerView.date.seconds(from: Date())
        print("----- get deltaSecs = ", deltaSecs)
        currSelectedDate = Date(timeIntervalSinceNow: currDaysInterval + TimeInterval(deltaSecs))
        
        print("----- timePickerView.date = ",timePickerView.date.description)
        print("----- currSelectDate = ", currSelectedDate.getCurrentLocalizedDate())
    }
    
    func addTimeButtonTapped(){
        print("TODO: addTimeButtonTapped!!!!")
        if requestController != nil {
            isStartingTime = true
            showUpAnimation(withTitle: "开始时间")

        }else if postTripControllerStartTime != nil {
            isStartingTime = false
            //showUpAnimation(withTitle: "旅行开始")
            timeSlicesInDay = [currSelectedDate]
            
        }else if postTripControllerPickupTime != nil {
            isStartingTime = true
            showUpAnimation(withTitle: "开始时间")

        }
    }
    
    func okButtonTapped(){
        if requestController != nil {
            print("TODO: okButtonTapped!! save all data and go back!!")

        }else
        if postTripControllerStartTime != nil {
            postTripControllerStartTime?.setupStartTime(date: currSelectedDate)
//        }else
//        if postTripControllerPickupTime != nil {
//            guard timeSlicesInDay.count > 1 else {
//                let msg = "您设置结束时间了吗？揽件截止时间应早于您的旅行出发时间哦！"
//                displayAlert(title: "深情提示", message: msg, action: "朕知道了")
//                return
//            }
//            timeSlicesInDay.sort()
//            postTripControllerPickupTime?.setupPickupTimeSlice(dateStart: timeSlicesInDay.first!, dateEnd: timeSlicesInDay.last!)
        }

        navigationController?.popViewController(animated: true)
                
    }
    
    
    func timePickerCancelButtonTapped(){
        print("timePickerCancelButtonTapped!!!!!")
        dismissAnimation()
    }
    
    func timePickerOkButtonTapped(){
        if requestController != nil {
            print("TODO: okButtonTapped!! save all data and go back!!")
            
        }else
        if postTripControllerStartTime != nil {
            dismissAnimation() // already save date in FSCalendar,didSelect date
        }else
        if postTripControllerPickupTime != nil {
            resetPickerTitleAndButtons(toStart: !isStartingTime)
            if !isStartingTime {
                
                dismissAnimation()
            }
            isStartingTime = !isStartingTime
        }
    }
    
    private func resetPickerTitleAndButtons(toStart:Bool){
        timePickerMenuTitleLabel.text = toStart ? "开始时间" : "结束时间"
        let titleStr = toStart ? "下一步" : "完成"
        timePickerButtonOk.setupAppearance(backgroundColor: .clear, title: titleStr, textColor: textThemeColor, fontSize: 16)
    }
    
    func showUpAnimation(withTitle: String){
        timePickerMenuTitleLabel.text = withTitle
        backgroundTransparentView.isHidden = false
        timePickerMenuView.isHidden = false
        timePickerMenuTopConstraint.constant = -(timePickerMenuView.bounds.height - timePickerBottomMargin)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.6, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func dismissAnimation(){
        timePickerMenuTopConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (complete) in
            self.backgroundTransparentView.isHidden = true
            self.timePickerMenuView.isHidden = true
        }
    }    
}
