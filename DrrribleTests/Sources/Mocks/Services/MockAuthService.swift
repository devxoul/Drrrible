//
//  MockAuthService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
import Then

@testable import Drrrible

final class MockAuthService: BaseService, AuthServiceType, Then {
  var currentAccessToken: AccessToken? {
    return nil
  }

  var authorizeClosure: () -> Observable<Void> = { return .never() }
  func authorize() -> Observable<Void> {
    return self.authorizeClosure()
  }

  func callback(code: String) {
  }

  func logout() {
  }
}
