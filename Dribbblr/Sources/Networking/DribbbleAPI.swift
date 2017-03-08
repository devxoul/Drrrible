//
//  DribbbleAPI.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Moya
import MoyaSugar

enum DribbbleAPI {
  case shots
}

extension DribbbleAPI: SugarTargetType {

  var baseURL: URL {
    return URL(string: "https://api.dribbble.com/v1")!
  }

  var route: Route {
    switch self {
    case .shots:
      return .get("/shots")
    }
  }

  var params: Parameters? {
    switch self {
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

  var sampleData: Data {
    return Data()
  }

}
