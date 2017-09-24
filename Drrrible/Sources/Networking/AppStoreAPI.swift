//
//  AppStore.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Moya
import MoyaSugar

enum AppStoreAPI {
  case lookup(bundleID: String)
}

extension AppStoreAPI: SugarTargetType {
  var baseURL: URL {
    return URL(string: "https://itunes.apple.com")!
  }

  var route: Route {
    switch self {
    case .lookup:
      return .get("lookup")
    }
  }

  var task: Task {
    switch self {
    case let .lookup(bundleID):
      return .requestParameters(parameters: ["bundleId": bundleID], encoding: URLEncoding())
    }
  }

  var headers: [String: String]? {
    return nil
  }

  var sampleData: Data {
    return Data()
  }
}
