//
//  Fixture.swift
//  DrrribleTests
//
//  Created by Suyeol Jeon on 25/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Foundation

func fixture<T: Decodable>(_ json: [String: Any?]) -> T {
  do {
    let data = try JSONSerialization.data(withJSONObject: json.filterNil(), options: [])
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(T.self, from: data)
  } catch let error {
    fatalError(String(describing: error))
  }
}
