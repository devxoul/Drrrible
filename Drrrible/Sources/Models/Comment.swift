//
//  Comment.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ObjectMapper

struct Comment: ModelType {

  enum Event {
  }

  var id: Int
  var body: String
  var createdAt: Date
  var likeCount: Int
  var user: User

  init(map: Map) throws {
    self.id = try map.value("id")
    self.body = try map.value("body")
    self.createdAt = try map.value("created_at", using: ISO8601DateTransform())
    self.likeCount = try map.value("likes_count")
    self.user = try map.value("user")
  }

}
