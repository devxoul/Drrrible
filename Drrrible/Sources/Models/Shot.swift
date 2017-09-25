//
//  Shot.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Foundation

struct Shot: ModelType {
  enum Event {
    case updateLiked(id: Int, isLiked: Bool)
    case increaseLikeCount(id: Int)
    case decreaseLikeCount(id: Int)
  }

  var id: Int
  var title: String
  var text: String?
  var user: User

  var imageURLs: ShotImageURLs
  var imageWidth: Int
  var imageHeight: Int
  var isAnimatedImage: Bool

  var viewCount: Int
  var likeCount: Int
  var commentCount: Int

  var createdAt: Date

  var isLiked: Bool? = nil

  enum CodingKeys: String, CodingKey {
    case id = "id"
    case title = "title"
    case text = "description"
    case user = "user"
    case imageURLs = "images"
    case imageWidth = "width"
    case imageHeight = "height"
    case isAnimatedImage = "animated"
    case viewCount = "views_count"
    case likeCount = "likes_count"
    case commentCount = "comments_count"
    case createdAt = "created_at"
  }
}

struct ShotImageURLs: Codable {
  let hidpi: URL?
  let normal: URL
  let teaser: URL

  enum CodingKeys: String, CodingKey {
    case hidpi = "hidpi"
    case normal = "normal"
    case teaser = "teaser"
  }
}
