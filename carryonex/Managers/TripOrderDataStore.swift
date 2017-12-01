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
    
    private var carrierTrips = [Trip]()
    private var senderTrips = [Trip]()
    
    private var carrierRequests = [Int: Request]()
    private var senderRequests = [Int: Request]()
    
    private var lastCarrierFetchTime: Int = -1
    private var lastSenderFetchTime: Int = -1
    
    func getTrips(category: TripCategory) -> [Trip] {
        let targetTrips = (category == .carrier) ? carrierTrips : senderTrips
        return targetTrips.sorted { (t1, t2) -> Bool in
            return (t1.timestamp > t2.timestamp)
        }
    }
    
    func pull(category: TripCategory) {
        let targetTrips = (category == .carrier) ? carrierTrips : senderTrips
        let pageCount = (targetTrips.count == 0) ? 10 : targetTrips.count
        let lastFetchTime = (category == .carrier) ? lastCarrierFetchTime : lastSenderFetchTime
        ApiServers.shared.getUsersTrips(userType: category, offset: 0, pageCount: pageCount, sinceTime: lastFetchTime) { (tripOrders, error) in
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
            
            print("carrier trip: \(self.carrierTrips.count), request: \(self.carrierRequests.count)")
            print("sender trip: \(self.senderTrips.count), request: \(self.senderRequests.count)")
        }
    }
    
    private func updateData(forCategory category: TripCategory, updatedData: [TripOrder]) {
        
        let targetTrips = (category == .carrier) ? carrierTrips : senderTrips
        let (newTripOrders, existingTripOrders) = self.getNewTripOrders(updatedData: updatedData, currentTrips: targetTrips)
        //Update request data before trip data, because request will need to check for trip data.
        updateTripData(forCategory: category, updatedData: existingTripOrders)
        updateRequestData(forCategory: category, updatedData: existingTripOrders)
        
        addNewTripData(forCategory: category, newTripOrders: newTripOrders)
        addNewRequestData(forCategory: category, newTripOrders: newTripOrders)
    }
    
    private func updateTripData(forCategory category: TripCategory, updatedData: [TripOrder]) {
        var targetTrips = (category == .carrier) ? carrierTrips : senderTrips
        //Handle trips
        for updatedTripOrder in updatedData {
            let trip = updatedTripOrder.trip
            let tripIndex = isExists(item: updatedTripOrder.trip, list: targetTrips)
            targetTrips[tripIndex] = trip
        }
        
        if category == .carrier { carrierTrips = targetTrips }
        else { senderTrips = targetTrips }
    }
    
    private func updateRequestData(forCategory category: TripCategory, updatedData: [TripOrder]) {
        var targetRequests = (category == .carrier) ? carrierRequests : senderRequests
        for updatedTripOrder in updatedData {
            let trip = updatedTripOrder
            if let requests = trip.requests {
                for request in requests {
                    let reqId = request.request.id
                    targetRequests[reqId] = request.request
                }
            }
        }
        
        if category == .carrier { carrierRequests = targetRequests }
        else { senderRequests = targetRequests }
    }
    
    private func addNewTripData(forCategory category: TripCategory, newTripOrders: [TripOrder]) {
        let newTrips = newTripOrders.map { (tripOrder) -> Trip in
            return tripOrder.trip
        }
        
        if (category == .carrier) {
            carrierTrips.append(contentsOf: newTrips)
        } else {
            senderTrips.append(contentsOf: newTrips)
        }
    }
    
    private func addNewRequestData(forCategory category: TripCategory, newTripOrders: [TripOrder]) {
        var targetRequests = (category == .carrier) ? carrierRequests : senderRequests
        for tripOrder in newTripOrders {
            if let tripRequests = tripOrder.requests {
                for tripReq in tripRequests {
                    let req = tripReq.request
                    targetRequests[req.id] = req
                }
            }
        }
    }
    
    private func getNewTripOrders(updatedData: [TripOrder], currentTrips: [Trip]) -> ([TripOrder], [TripOrder]) {
        var newTripOrders = [TripOrder]()
        var existingTripOrders = [TripOrder]()
        for tripOrder in updatedData {
            let trip = tripOrder.trip
            let tripIndex = isExists(item: trip, list: currentTrips)
            if tripIndex == -1 {
                newTripOrders.append(tripOrder)   //add new trip to append all at once
            } else {
                existingTripOrders.append(tripOrder)
            }
        }
        return (newTripOrders, existingTripOrders)
    }
    
    private func isExists(item: Identifiable, list: [Identifiable]) -> Int {
        var index = -1
        for i in 0..<list.count {
            let listItem = list[i]
            if listItem.id == item.id {
                index = i   //trip found
                return index
            }
        }
        return index
    }
}
