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
//        let ok1 = "朕知道了",
        let ok2 = "嗯，平身吧"
        guard isStartAddressSetted, isEndAddressSetted else {
            displayAlert(title: tit, message: "\(msg)请选择【出发地和目的地】。", action: ok2)
            return
        }
        
        uploadTripToServer()
    }
    
    
    private func uploadTripToServer(){
        guard let start = self.addressStarting, let destination = self.addressDestinat else {
            return
        }
        
        //Set address for trip
        self.trip.startAddress = start
        self.trip.endAddress = destination
        
        activityIndicator.startAnimating()
        
        ApiServers.shared.postTripInfo(trip: self.trip) { (success, msg, id) in
            if success {
                
                if let msg = msg, let id = id {
                    print("get callback after uploadTripToServer(), success = \(success), msg = \(msg), tripID: \(id)")
                }
                // today: remove this if not workinig:
//                let waitingCtl = WaitingController()
//                waitingCtl.isForShipper = true
//                self.present(waitingCtl, animated: true, completion: nil)
                self.showWaitingPageWithTransition()

            } else {
                if let msg = msg {
                    let m = "抱歉给您带来的不便，请保持网络连接，稍后再试一次吧！错误信息：\(msg)"
                    self.displayAlert(title: "⚠️上传失败了", message: m, action: "朕知道了")
                }
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func showWaitingPageWithTransition(){
        self.navigationController?.pushViewController(WaitingController(), animated: false)
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
    }
    func setupEndAddress(string: String){
        isEndAddressSetted = true
        endAddressCell?.infoLabel.textColor = .black
        endAddressCell?.infoLabel.text = string
        okButtonValidateCheck()
    }
    func setupStartTime(date: Date){
        trip.pickupDate = date.timeIntervalSince1970
        startTimeCell?.infoLabel.textColor = .black
        startTimeCell?.infoLabel.text = dateFormatter.string(from: date)
        okButtonValidateCheck()
    }
    
    private func okButtonValidateCheck(){
        let isOk = isStartAddressSetted && isEndAddressSetted
        okButton.backgroundColor = isOk ? buttonThemeColor : UIColor.lightGray
        okButton.isEnabled = isOk
    }
    
    func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

