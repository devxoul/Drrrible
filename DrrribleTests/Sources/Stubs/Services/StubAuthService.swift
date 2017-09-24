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
    return Stubber.invoke(authorize, args: (), default: .never())
  }

  func callback(code: String) {
    Stubber.invoke(callback, args: code, default: Void())
  }

  func logout() {
    Stubber.invoke(logout, args: (), default: Void())
  }
}
