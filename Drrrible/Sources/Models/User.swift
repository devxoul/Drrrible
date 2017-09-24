//
//  User.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Foundation

struct User: ModelType {
  enum Event {
  }

  var id: Int
  var name: String
  var avatarURL: URL?
  var bio: String?
  var isPro: Bool

  var shotCount: Int
  var followerCount: Int
  var followingCount: Int

  enum CodingKeys: String, CodingKey {
    case id = "id"
    case name = "name"
    case avatarURL = "avatar_url"
    case bio = "bio"
    case isPro = "pro"
    case shotCount = "shots_count"
    case followerCount = "followers_count"
    case followingCount = "followings_count"
  }
}
