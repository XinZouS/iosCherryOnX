//
//  PostTripController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/29/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension PostTripController {
    

    
    
    func okButtonTapped(sender:UIButton){
        let tit = "启禀皇上"
        let msg = "❓"
        let ok1 = "朕知道了", ok2 = "嗯，平身吧"
        guard isTransportationSetted else {
            displayAlert(title: tit, message: "\(msg)请选择您的【交通方式】。", action: ok1)
            return
        }
        guard isStartAddressSetted, isEndAddressSetted else {
            displayAlert(title: tit, message: "\(msg)请选择【出发地和目的地】。", action: ok2)
            return
        }
        guard isStartTimeSetted else {
            displayAlert(title: tit, message: "\(msg)请挑个【出发时间】的吉日吧。", action: ok1)
            return
        }
//        guard isPickUpTimeSetted else {
//            displayAlert(title: tit, message: "\(msg)请选个吉时作为【取货时间段】。", action: ok2)
//            return
//        }
        
        let waitingCtl = WaitingController()
        waitingCtl.isForShipper = true
        present(waitingCtl, animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: false)

        uploadAddressToServer(addressStarting!)
        uploadAddressToServer(addressDestinat!)
        uploadTripToServer()
    }
    
    private func uploadAddressToServer(_ addr : Address){
        print("TODO: parse address to JSON and upload to server and get addressId back...")
        
        var country:[String:Country] = [:]
        country["country"] = addr.country
        var json:[String:String] = [:]
        json["city"] = addr.city
        json["detailAddress"] = addr.detailAddress
        json["zipCode"] = addr.zipcode
        json["recipientName"] = addr.recipientName
        json["phoneNumber"] = addr.phoneNumber
    }
    private func uploadTripToServer(){
        ApiServers.shared.postTripInfo(trip: self.trip)
    }

    func transportationCellButtonTapped(){
        switch trip.transportation {
        case .airplane:
            trip.transportation = .bus
            
        case .bus:
            trip.transportation = .car
            
        case .car:
            trip.transportation = .airplane
            
        default:
            trip.transportation = .airplane
        }
        isTransportationSetted = true
    }
    
    func startAddressButtonTapped(){
        let addressSearchCtl = AddressSearchController()
        addressSearchCtl.searchType = AddressSearchType.tripStarting
        addressSearchCtl.postTripCtl = self
        navigationController?.pushViewController(addressSearchCtl, animated: true)
    }
    
    func endAddressButtonTapped(){
        let addressSearchCtl = AddressSearchController()
        addressSearchCtl.searchType = AddressSearchType.tripDestination
        addressSearchCtl.postTripCtl = self
        navigationController?.pushViewController(addressSearchCtl, animated: true)
    }
    
    func startTimeButtonTapped(){
        pushSendingTimeController(isStartTime: true)
    }
    func pickupTimeButtonTapped(){
        pushSendingTimeController(isStartTime: false)
    }
    private func pushSendingTimeController(isStartTime: Bool){
        let sendingTimeCtl = SendingTimeController()
        sendingTimeCtl.postTripControllerStartTime = isStartTime ? self : nil
        sendingTimeCtl.postTripControllerPickupTime = isStartTime ? nil : self
        sendingTimeCtl.trip = self.trip
        navigationController?.pushViewController(sendingTimeCtl, animated: true)
    }
    
    
    // MARK: - setup cell info
    
    func setupStartingAddress(string: String){
        isStartAddressSetted = true
        startAddressCell?.infoLabel.textColor = .black
        startAddressCell?.infoLabel.text = string
        okButtonValidateCheck()
        print("setupStartingAddress: ", string)
    }
    func setupEndAddress(string: String){
        isEndAddressSetted = true
        endAddressCell?.infoLabel.textColor = .black
        endAddressCell?.infoLabel.text = string
        okButtonValidateCheck()
        print("setupEndAddress: ", string)
    }
    func setupStartTime(date: Date){
        isStartTimeSetted = true
        startTimeCell?.infoLabel.textColor = .black
        startTimeCell?.infoLabel.text = dateFormatter.string(from: date)
        okButtonValidateCheck()
    }
//    func setupPickupTimeSlice(dateStart: Date, dateEnd: Date){
//        pickUpTimeCell?.infoLabel.textColor = .black
//        let d1 = dateFormatter.string(from: dateStart)
//        let d2 = dateFormatter.string(from: dateEnd)
//        pickUpTimeCell?.infoLabel.text = "\(d1) -- \(d2)"
//    }
    private func okButtonValidateCheck(){
        let isOk = isTransportationSetted && isStartAddressSetted && isEndAddressSetted && isStartTimeSetted
        okButton.backgroundColor = isOk ? buttonThemeColor : UIColor.lightGray
        okButton.isEnabled = isOk
    }
    
    func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Pop alert view
extension PostTripController {
    
    func displayAlert(title: String, message: String, action: String) {
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        v.addAction(action)
        present(v, animated: true, completion: nil)
    }
    
}


