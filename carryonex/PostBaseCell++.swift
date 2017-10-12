//
//  PostBaseCell++.swift
//  carryonex
//
//  Created by Xin Zou on 8/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension PostBaseCell {
    
    
    func infoButtonTapped(){
        print("cell tapped with idString: \(self.idString)")
        switch self.idString {
        case postTripController.transportationCellId:
            reactForTransportation()
        case postTripController.startAddressCellId:
            reactForStartAddress()
        case postTripController.endAddressCellId:
            reactForEndAddress()
        case postTripController.startTimeCellId:
            reactForStartTime()
        case postTripController.pickUpTimeCellId:
            reactForPickupTime()
        default:
            print("default cell tapped!!!!")
        }
        
    }
    
    private func reactForTransportation(){
        print("postTripController.transportationCellButtonTapped()...")
        postTripController.transportationCellButtonTapped()
        infoLabel.textColor = .black
        infoLabel.text = postTripController.trip.transportation.rawValue
    }
    private func reactForStartAddress(){
        postTripController.startAddressButtonTapped()
    }
    private func reactForEndAddress(){
        postTripController.endAddressButtonTapped()
    }
    private func reactForStartTime(){
        postTripController.startTimeButtonTapped()
    }
    private func reactForPickupTime(){
        postTripController.pickupTimeButtonTapped()
    }
    
    

    
}
