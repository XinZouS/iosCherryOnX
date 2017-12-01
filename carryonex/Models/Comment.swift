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
    case realName = "real_name"
    case comment = "comment"
    case rank = "rank"
    case imageUrl = "image_url"
    case timestamp = "timestamp"
    case commentId = "comment_id"
    
    //POST ONLY
    case commenteeId = "commentee_id"
    case commenterId = "commenter_id"
}

struct Comment {
    let id: Int
    let comment: String
    let realName: String?
    let rank: Float?
    let timestamp: Int
    let imageUrl: String?
}

extension Comment: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: CommentKey.commenterId.rawValue)
        self.comment = try unboxer.unbox(key: CommentKey.comment.rawValue)
        self.realName = try? unboxer.unbox(key: CommentKey.realName.rawValue)
        self.rank = try? unboxer.unbox(key: CommentKey.rank.rawValue)
        self.timestamp = try unboxer.unbox(key: CommentKey.timestamp.rawValue)
        self.imageUrl = try? unboxer.unbox(key: CommentKey.imageUrl.rawValue)
    }
}
