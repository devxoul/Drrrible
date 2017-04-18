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

  var params: Parameters? {
    switch self {
    case let .lookup(bundleID):
      return ["bundleId": bundleID]
    }
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    return .request
  }
}
