//
//  DribbbleAPI.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Moya
import MoyaSugar

enum DribbbleAPI {
  case url(URL)
  case me
  case shots
  case shot(id: Int)
}

extension DribbbleAPI: SugarTargetType {

  var baseURL: URL {
    return URL(string: "https://api.dribbble.com/v1")!
  }

  var url: URL {
    switch self {
    case .url(let url):
      return url
    default:
      return self.defaultURL
    }
  }

  var route: Route {
    switch self {
    case .url:
      return .get("")

    case .me:
      return .get("/user")

    case .shots:
      return .get("/shots")

    case let .shot(id):
      return .get("/shots/\(id)")
    }
  }

  var params: Parameters? {
    switch self {
    case .shots:
      return ["per_page": 100]

    default:
      return nil
    }
  }

  var task: Task {
    switch self {
    default:
      return .request
    }
  }

  var httpHeaderFields: [String: String]? {
    return ["Accept": "application/json"]
  }

  var sampleData: Data {
    return Data()
  }

}
