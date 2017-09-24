//
//  AccessToken.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

struct AccessToken: ModelType {
  enum Event {
  }

  var accessToken: String
  var tokenType: String
  var scope: String

  init(accessToken: String, tokenType: String, scope: String) {
    self.accessToken = accessToken
    self.tokenType = tokenType
    self.scope = scope
  }

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
    case scope = "scope"
  }
}
