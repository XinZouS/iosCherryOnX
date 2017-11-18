//
//  UserComments.swift
//  carryonex
//
//  Created by Zian Chen on 11/17/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Unbox

enum UserCommentsKey: String {
    case rank = "rank"
    case comments = "comments"
    case commentsLength = "comments_length"
}

struct UserComments {
    let rank: Float
    let comments: [Comment]
    let commentsLength: Int
}

extension UserComments: Unboxable {
    init(unboxer: Unboxer) throws {
        self.rank = try unboxer.unbox(key: UserCommentsKey.rank.rawValue)
        self.comments = try unboxer.unbox(key: UserCommentsKey.comments.rawValue)
        self.commentsLength = try unboxer.unbox(key: UserCommentsKey.commentsLength.rawValue)
    }
}
