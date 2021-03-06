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
    
    private let pullPageCount = 10
    
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
            return r1.timestamp > r2.timestamp
        })
    }
    
    func getTrip(category: TripCategory, id: Int?) -> Trip? {
        guard let id = id else { return nil }
        let targetTrips = (category == .carrier) ? carrierTrips : senderTrips
        return targetTrips[id]
    }
    
    func getRequestsByTripId(category: TripCategory, tripId: Int?) -> [Request] {
        guard let tripId = tripId else { return [Request]() }
        let targetRequests = (category == .carrier) ? carrierRequests : senderRequests
        return targetRequests.values.filter({ (req) -> Bool in
            return req.tripId == tripId
        })
    }
    
    func getRequest(requestId: Int) -> Request? {
        if let request = carrierRequests[requestId] {
            return request
        }
        return senderRequests[requestId]
    }
    
    func getRequest(category: TripCategory, requestId: Int) -> Request? {
        let targetRequests = (category == .carrier) ? carrierRequests : senderRequests
        return targetRequests[requestId]
    }
    
    func updateRequestFromRemote(requestId: Int, completion:((Request?) -> Void)?) {
        ApiServers.shared.getRequestInfo(id: requestId) { (request, error) in
            if let error = error {
                DLog("updateRequestFromRemote error: \(error.localizedDescription)")
                return
            }
            
            if let request = request, let category = request.category() {
                if category == .carrier {
                    self.carrierRequests[request.id] = request
                } else {
                    self.senderRequests[request.id] = request
                }
            }
            
            completion?(request)
            NotificationCenter.default.post(name: NSNotification.Name.TripOrderStore.StoreUpdated, object: nil)
        }
    }
    
    func getCardItems() -> [(Request, TripCategory)]? {

        let carrierSortedItems = prioritySortedRequests(category: .carrier)
        let senderSortedItems = prioritySortedRequests(category: .sender)
        
        if carrierSortedItems == nil && senderSortedItems == nil {
            return nil
        
        } else if carrierSortedItems != nil && senderSortedItems == nil {
            return carrierSortedItems
        
        } else if senderSortedItems != nil && carrierSortedItems == nil {
            return senderSortedItems
        
        } else {
            let carrierSorted = carrierSortedItems!
            let senderSorted = senderSortedItems!
            if carrierSorted.count > 1 {
                let secondCarrierItem = carrierSorted[1]
                if secondCarrierItem.0.status().prioritySortIndex(category: .carrier) > senderSorted.first!.0.status().prioritySortIndex(category: .sender) {
                    return carrierSorted
                }
            }
            
            if senderSorted.count > 1 {
                let secondSenderItem = senderSorted[1]
                if secondSenderItem.0.status().prioritySortIndex(category: .sender) > carrierSorted.first!.0.status().prioritySortIndex(category: .carrier) {
                    return senderSorted
                }
            }
            return [carrierSorted.first!, senderSorted.first!]
        }
    }
    
    public func updateRequestToStatus(category: TripCategory, requestId: Int, status: Int) {
        if let request = getRequest(category: category, requestId: requestId) {
            request.statusId = status
            
            if category == .carrier {
                carrierRequests[request.id] = request
            } else {
                senderRequests[request.id] = request
            }
            NotificationCenter.default.post(name: NSNotification.Name.TripOrderStore.StoreUpdated, object: nil)
        }
    }
    
    public func updateRequestToCommented(category: TripCategory, requestId: Int) {
        if let request = getRequest(category: category, requestId: requestId) {
            
            if category == .carrier {
                if request.commentStatus == CommentStatus.SenderCommented.rawValue {
                    request.commentStatus = CommentStatus.Completed.rawValue
                } else {
                    request.commentStatus = CommentStatus.CarrierCommented.rawValue
                }
                carrierRequests[request.id] = request
                
            } else {
                if request.commentStatus == CommentStatus.CarrierCommented.rawValue {
                    request.commentStatus = CommentStatus.Completed.rawValue
                } else {
                    request.commentStatus = CommentStatus.SenderCommented.rawValue
                }
                senderRequests[request.id] = request
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.TripOrderStore.StoreUpdated, object: nil)
        }
    }
    
    public func updateRequestWithExpress(express: Express, category: TripCategory, requestId: Int) {
        
        if let request = getRequest(category: category, requestId: requestId) {
            
            if category == .carrier {
                request.express = express
                carrierRequests[request.id] = request
                
            } else {
                request.express = express
                senderRequests[request.id] = request
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.TripOrderStore.StoreUpdated, object: nil)
        }
    }
    
    private func prioritySortedRequests(category: TripCategory) -> [(Request, TripCategory)]? {
        
        let requests = (category == .carrier) ? carrierRequests : senderRequests
        
        if requests.count == 0 {
            return nil
        }
        
        return requests.values.sorted { (r1, r2) -> Bool in
            return r1.status().prioritySortIndex(category: category) > r2.status().prioritySortIndex(category: category)
        }.map { (req) -> (Request, TripCategory) in
            return (req, category)
        }
    }
    
    func pullNextPage(category: TripCategory, completion:(() -> Void)?) {
        let targetTrips = (category == .carrier) ? carrierTrips : senderTrips
        let offset = targetTrips.count
        let pageCount = pullPageCount
        let lastFetchTime = -1
        
        fetchData(forCategory: category, offset: offset, pageCount: pageCount, sinceTime: lastFetchTime) {[weak self] (tripOrders) in
            //Only notify update when there are actual substantial update.
            if let tripOrders = tripOrders {
                self?.updateData(forCategory: category, updatedData: tripOrders)
                NotificationCenter.default.post(name: NSNotification.Name.TripOrderStore.StoreUpdated, object: nil)
            }
            completion?()
        }
    }
    
    func pull(category: TripCategory, delay: Int = 0, shouldNotify: Bool = true, completion:(() -> Void)?) {
        let targetTrips = (category == .carrier) ? carrierTrips : senderTrips
        let offset = 0
        let pageCount = (targetTrips.count == 0) ? pullPageCount : targetTrips.count   //first pull 10 items
        let lastFetchTime = (category == .carrier) ? lastCarrierFetchTime : lastSenderFetchTime
        fetchData(forCategory: category, offset: offset, pageCount: pageCount, sinceTime: lastFetchTime) {[weak self] (tripOrders) in
            //Only notify update when there are actual substantial update.
            if let tripOrders = tripOrders {
                self?.updateData(forCategory: category, updatedData: tripOrders)
                if shouldNotify {
                    NotificationCenter.default.post(name: NSNotification.Name.TripOrderStore.StoreUpdated, object: nil)
                }
            }
            completion?()
        }
    }
    
    func pullAll(delay: Int = 0, completion:(() -> Void)?) {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        pull(category: .carrier, shouldNotify: false) { _ in
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        pull(category: .sender, shouldNotify: false) { _ in
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            NotificationCenter.default.post(name: NSNotification.Name.TripOrderStore.StoreUpdated, object: nil)
            completion?()
        }
    }
    
    func clearStore(){
        carrierTrips.removeAll()
        senderTrips.removeAll()
        carrierRequests.removeAll()
        senderRequests.removeAll()
        lastSenderFetchTime = -1
        lastCarrierFetchTime = -1
        NotificationCenter.default.post(name: NSNotification.Name.TripOrderStore.StoreUpdated, object: nil)
    }
    
    private func fetchData(forCategory category: TripCategory, offset: Int, pageCount: Int, sinceTime: Int, delay: Int = 0, completion:(([TripOrder]?) -> Void)?) {
        
        DLog("PULL CATEGORY: \(category)")
        
        ApiServers.shared.getUsersTrips(userType: category, offset: offset, pageCount: pageCount) { (tripOrders, error) in
            if let error = error {
                DLog("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
                return
            }
            
            if let tripOrders = tripOrders {
                completion?(tripOrders)
            } else {
                completion?(nil)
                DLog("No new update since: \(sinceTime)")
            }
            
            if category == .carrier {
                self.lastCarrierFetchTime = Date.getTimestampNow()
                DLog("carrier trip: \(self.carrierTrips.count), request: \(self.carrierRequests.count)")
            } else {
                self.lastSenderFetchTime = Date.getTimestampNow()
                DLog("sender trip: \(self.senderTrips.count), request: \(self.senderRequests.count)")
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
