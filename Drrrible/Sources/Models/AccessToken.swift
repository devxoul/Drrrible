//
//  AccessToken.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ObjectMapper

struct AccessToken: ModelType {

  var accessToken: String
  var tokenType: String
  var scope: String

  init(accessToken: String, tokenType: String, scope: String) {
    self.accessToken = accessToken
    self.tokenType = tokenType
    self.scope = scope
  }

  init(map: Map) throws {
    self.accessToken = try map.value("access_token")
    self.tokenType = try map.value("token_type")
    self.scope = try map.value("scope")
  }

}
