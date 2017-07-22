//
//  MockAuthService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
@testable import Drrrible

final class MockAuthService: AuthServiceType, MockService {
  var currentAccessToken: AccessToken? {
    return nil
  }

  func authorize() -> Observable<Void> {
    return self.call(Self.authorize)
  }

  func callback(code: String) {
    self.call(Self.callback, args: code)
  }

  func logout() {
    self.call(Self.logout)
  }
}
