//
//  ModelType.swift
//  Dribbble
//
//  Created by Suyeol Jeon on 10/02/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Then

protocol ModelType: Codable, Then {
  associatedtype Event

  static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension ModelType {
  static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
    return .iso8601
  }

  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = self.dateDecodingStrategy
    return decoder
  }
}
