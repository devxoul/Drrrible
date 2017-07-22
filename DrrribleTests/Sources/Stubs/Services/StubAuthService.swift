//
//  StubAuthService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
@testable import Drrrible

final class StubAuthService: AuthServiceType, Stub {
  var currentAccessToken: AccessToken? {
    return nil
  }

  func authorize() -> Observable<Void> {
    return self.call(authorize)
  }

  func callback(code: String) {
    self.call(callback, args: code)
  }

  func logout() {
    self.call(logout)
  }
}
