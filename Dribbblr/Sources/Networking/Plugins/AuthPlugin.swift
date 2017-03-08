//
//  AuthPlugin.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Moya

struct AuthPlugin: PluginType {

  fileprivate let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request = request
    if let accessToken = self.provider.authService.accessToken?.accessToken {
      request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
    return request
  }

}
