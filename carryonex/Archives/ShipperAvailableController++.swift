//
//  ShipperAvailableController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/26/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


/// MARK: calendar delegate

extension ShipperAvailableController {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        DLog("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        DLog("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    // UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = true //self.collectionView.contentOffset.y <= -self.collectionView.contentInset.top
        // collectionView.contentOffset.y is ONLY for panGesture when collectionView NOT ont top or bottom;
        
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
        DLog("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}


/// MARK: collectionView delegate

extension ShipperAvailableController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // AM, PM
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return timeOffsetsAM.count
        case 1:
            return timeOffsetsPM.count
        default:
            return 3
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timeCellId, for: indexPath) as! ShipperAvailableCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let refDateTime = formatter.date(from: "2017/08/08 00:00")
        let delta : Int!
        let timeComponents: Set<Calendar.Component> = [.hour, .minute]
        
        if indexPath.section == 0 {
            delta = timeOffsetsAM[indexPath.item]
        }else{
            delta = timeOffsetsPM[indexPath.item]
        }
        let time = refDateTime?.addingTimeInterval(TimeInterval(delta)) ?? Date()
        let components = Calendar.current.dateComponents(timeComponents, from: time)
        let hh = components.hour ?? 0
        let mm = components.minute ?? 0
        cell.titleLabel.text = "\(hh):\(mm)"
        
        cell.timeOffset = delta
        cell.isSelectionEnable = indexPath.item % 4 == 1
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = (view.bounds.width - collectionViewSideMargin * 2) / 4 - 8 // - cell margin
        let h: CGFloat = 30
        return CGSize(width: w, height: h)
    }
    // for cell appearance setup with selection:
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ShipperAvailableCell {
            cell.setupCellAppearance(isSelecting: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ShipperAvailableCell {
            cell.setupCellAppearance(isSelecting: false)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //let xRow = Int(targetContentOffset.pointee.y )
    }

}

/// MARK: buttonTapped func

extension ShipperAvailableController {
    
    func finishButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    func buttonAMPMTapped(){
        isAMSelected = !isAMSelected
        
        labelAM.font = UIFont.systemFont(ofSize: isAMSelected ? 16 : 14, weight: isAMSelected ? 2 : 0)
        labelPM.font = UIFont.systemFont(ofSize: isAMSelected ? 14 : 16, weight: isAMSelected ? 0 : 2)
        
        let idxPath = IndexPath(item: 0, section: isAMSelected ? 0 : 1)
        collectionView.scrollToItem(at: idxPath, at: .top, animated: true)
    }
    
    
    
}
