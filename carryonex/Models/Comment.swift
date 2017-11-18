//
//  Comment.swift
//  carryonex
//
//  Created by Zian Chen on 11/17/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox

enum CommentKey: String {
    case id = "id"
    case showName = "show_name"
    case comment = "comment"
    case rank = "rank"
    case imageUrl = "image_url"
    case timestamp = "timestamp"
    
    //POST ONLY
    case commenteeId = "commentee_id"
    case commenterId = "commenter_id"
}

struct Comment {
    let id: Int
    let comment: String
    let rank: Float
    let timestamp: Int
    let showName: String
    let imageUrl: String
}

extension Comment: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.comment = try unboxer.unbox(key: "comment")
        self.showName = try unboxer.unbox(key: "commenter_username")
        //self.showName = try unboxer.unbox(key: "show_name")   //TODO
        self.rank = try unboxer.unbox(key: "rank")
        self.timestamp = try unboxer.unbox(key: "timestamp")
        self.imageUrl = try unboxer.unbox(key: "image_url")
    }
}
