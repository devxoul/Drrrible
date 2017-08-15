//
//  AuthPlugin.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Moya

struct AuthPlugin: PluginType {
  fileprivate let authService: AuthServiceType

  init(authService: AuthServiceType) {
    self.authService = authService
  }

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request = request
    if let accessToken = self.authService.currentAccessToken?.accessToken {
      request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
    return request
  }
}
