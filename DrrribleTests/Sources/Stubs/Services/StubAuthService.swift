//
//  StubAuthService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
import Stubber
@testable import Drrrible

final class StubAuthService: AuthServiceType {
  var currentAccessToken: AccessToken? {
    return nil
  }

  func authorize() -> Observable<Void> {
    return Stubber.stubbed(authorize, args: (), default: .empty())
  }

  func callback(code: String) {
    Stubber.stubbed(callback, args: code, default: Void())
  }

  func logout() {
    Stubber.stubbed(logout, args: (), default: Void())
  }
}
