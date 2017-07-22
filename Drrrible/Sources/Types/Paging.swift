//
//  Paging.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Foundation

enum Paging {
  case refresh
  case next(URL)
}

extension Paging: Equatable {
  static func == (lhs: Paging, rhs: Paging) -> Bool {
    switch (lhs, rhs) {
    case (.refresh, .refresh):
      return true

    case let (.next(a), .next(b)) where a == b:
      return true

    default:
      return false
    }
  }
}
