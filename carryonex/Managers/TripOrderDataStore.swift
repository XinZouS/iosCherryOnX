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
    
    private var carrierTrips = [Int: Trip]()
    private var senderTrips = [Int: Trip]()
    
    private var carrierRequests = [Int: Request]()
    private var senderRequests = [Int: Request]()
    
    private var lastCarrierFetchTime: Int = -1
    private var lastSenderFetchTime: Int = -1
    
    func getCarrierTrips() -> [Trip] {
        return carrierTrips.values.sorted { (t1, t2) -> Bool in
            return (t1.timestamp > t2.timestamp)
        }
    }
    
    func getSenderRequests() -> [Request] {
        return senderRequests.values.sorted(by: { (r1, r2) -> Bool in
            return r1.id > r2.id
        })
    }
    
    func getTrip(category: TripCategory, id: Int) -> Trip? {
        let targetTrips = (category == .carrier) ? carrierTrips : senderTrips
        return targetTrips[id]
    }
    
    func getRequestsByTripId(category: TripCategory, tripId: Int) -> [Request] {
        let targetRequests = (category == .carrier) ? carrierRequests : senderRequests
        return targetRequests.values.filter({ (req) -> Bool in
            return req.tripId == tripId
        })
    }
    
    func getRequest(category: TripCategory, requestId: Int) -> Request? {
        let targetRequests = (category == .carrier) ? carrierRequests : senderRequests
        return targetRequests[requestId]
    }
    
    func pull(category: TripCategory, completion:(() -> Void)?) {
        let targetTrips = (category == .carrier) ? carrierTrips : senderTrips
        let pageCount = (targetTrips.count == 0) ? 10 : targetTrips.count   //first pull 10 items
        let lastFetchTime = (category == .carrier) ? lastCarrierFetchTime : lastSenderFetchTime
        
        ApiServers.shared.getUsersTrips(userType: category, offset: 0, pageCount: pageCount, sinceTime: lastFetchTime) { (tripOrders, error) in
            if let error = error {
                print("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
                return
            }
            
            if let tripOrders = tripOrders {
                self.updateData(forCategory: category, updatedData: tripOrders)
                completion?()
                //Only notify update when there are actual substantial update.
                NotificationCenter.default.post(name: NSNotification.Name.TripOrderStore.StoreUpdated, object: nil)
            } else {
                print("No new update since: \(lastFetchTime)")
            }
            
            if category == .carrier {
                self.lastCarrierFetchTime = Date.getTimestampNow()
                print("carrier trip: \(self.carrierTrips.count), request: \(self.carrierRequests.count)")
            } else {
                self.lastSenderFetchTime = Date.getTimestampNow()
                print("sender trip: \(self.senderTrips.count), request: \(self.senderRequests.count)")
            }
        }
    }
    
    private func updateData(forCategory category: TripCategory, updatedData: [TripOrder]) {
        
        let targetTrips = (category == .carrier) ? carrierTrips : senderTrips
        let (newTripOrders, existingTripOrders) = self.getNewTripOrders(updatedData: updatedData, currentTrips: Array(targetTrips.values))
        
        //NOTE: Maybe we should combine update request data + add new request data
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
            targetTrips[trip.id] = trip
        }
        
        if category == .carrier { carrierTrips = targetTrips }
        else { senderTrips = targetTrips }
    }
    
    private func updateRequestData(forCategory category: TripCategory, updatedData: [TripOrder]) {
        var targetRequests = (category == .carrier) ? carrierRequests : senderRequests
        for updatedTripOrder in updatedData {
            let trip = updatedTripOrder
            if let tripRequests = trip.requests {
                for tripRequest in tripRequests {
                    let request = tripRequest.request
                    targetRequests[request.id] = request
                }
            }
        }
        
        if category == .carrier { carrierRequests = targetRequests }
        else { senderRequests = targetRequests }
    }
    
    private func addNewTripData(forCategory category: TripCategory, newTripOrders: [TripOrder]) {
        for tripOrder in newTripOrders {
            let trip = tripOrder.trip
            if (category == .carrier) {
                carrierTrips[trip.id] = trip
            } else {
                senderTrips[trip.id] = trip
            }
        }
    }
    
    private func addNewRequestData(forCategory category: TripCategory, newTripOrders: [TripOrder]) {
        for tripOrder in newTripOrders {
            if let tripRequests = tripOrder.requests {
                for tripReq in tripRequests {
                    let req = tripReq.request
                    if (category == .carrier) {
                        carrierRequests[req.id] = req
                    } else {
                        senderRequests[req.id] = req
                    }
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