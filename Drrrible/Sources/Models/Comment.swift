//
//  Comment.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Foundation

struct Comment: ModelType {
  enum Event {
  }

  var id: Int
  var body: String
  var createdAt: Date
  var likeCount: Int
  var user: User

  enum CodingKeys: String, CodingKey {
    case id = "id"
    case body = "body"
    case createdAt = "created_at"
    case likeCount = "likes_count"
    case user = "user"
  }
}
