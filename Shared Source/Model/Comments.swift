//
//  Comments.swift
//  Shared Source
//
//  Created by Derik Malcolm on 10/10/17.
//  Copyright © 2017 Derik Malcolm. All rights reserved.
//

import Foundation

struct Comments {
    var userId: String? // The user that posted the comment
    var username: String? // The username for the user that posted the comment
    var postId: String? // The post the comment is for
    var text: String? // The comments text
    var timestamp: NSNumber?
}
