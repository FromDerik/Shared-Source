//
//  Posts.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/2/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import Foundation

struct Posts {
    var userId: String? // Unique id for the user that created the post
    var username: String? // Username for the user that created the post
    var postId: String? // Unique id of the post
    var title: String? // Title of the post
    var post: String? // Text of the post
    var timestamp: NSNumber?
}
