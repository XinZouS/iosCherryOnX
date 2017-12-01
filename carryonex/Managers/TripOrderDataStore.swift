//
//  TripOrderDataStore.swift
//  carryonex
//
//  Created by Zian Chen on 11/30/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class TripOrderDataStore: NSObject {
    static let shared = TripOrderDataStore()
    
    var carrierTrips = [Trip]()
    var senderTrips = [Trip]()
    var carrierRequests = [String: Request]()
    var senderRequests = [String: Request]()
    
    private var lastCarrierFetchTime: Int = -1
    private var lastSenderFetchTime: Int = -1
    
    func pull(category: TripCategory) {
        let targetTrips = (category == .carrier) ? carrierTrips : senderTrips
        ApiServers.shared.getUsersTrips(userType: category, offset: targetTrips.count, pageCount: 10, sinceTime: lastCarrierFetchTime) { (tripOrders, error) in
            if let error = error {
                print("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
                return
            }
            
            if let tripOrders = tripOrders {
                self.updateData(forCategory: category, updatedData: tripOrders)
            }
            
            if category == .carrier {
                self.lastCarrierFetchTime = Date.getTimestampNow()
            } else {
                self.lastSenderFetchTime = Date.getTimestampNow()
            }
        }
    }
    
    private func updateData(forCategory category: TripCategory, updatedData: [TripOrder]) {
        
        updateTripsData(forCategory: category, updatedData: updatedData)
        
        //var targetRequests = (category == .carrier) ? carrierRequests : senderRequests
        //var newRequests = [Request]()
        
        //Handle requests
    }
    
    private func updateTripsData(forCategory category: TripCategory, updatedData: [TripOrder]) {
        
        var targetTrips = (category == .carrier) ? carrierTrips : senderTrips
        var newTrips = [Trip]()
        
        //Handle trips
        for updatedTripOrder in updatedData {
            let trip = updatedTripOrder.trip
            var index = -1
            
            for i in 0..<targetTrips.count {
                let newTrip = targetTrips[i]
                if trip.id == newTrip.id {
                    index = i   //trip found
                    break
                }
            }
            
            if index == -1 {
                newTrips.append(trip)   //add new trip to append all at once
            } else {
                targetTrips[index] = trip   //replace the trip
            }
        }
        
        targetTrips.append(contentsOf: newTrips)
        targetTrips.sort { (t1, t2) -> Bool in
            return (t1.timestamp > t2.timestamp)
        }
    }
}
