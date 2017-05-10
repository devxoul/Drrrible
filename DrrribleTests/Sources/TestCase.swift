//
//  TestCase.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest

import RxSwift

@testable import Drrrible

class TestCase: XCTestCase {
  override func setUp() {
    UIApplication.shared.delegate = MockAppDelegate()
    self.registerDependencies()
  }

  func registerDependencies() {
    DI.autoregister(AuthServiceType.self, initializer: MockAuthService.init)
    DI.autoregister(UserServiceType.self, initializer: MockUserService.init)
    DI.autoregister(ShotServiceType.self, initializer: MockShotService.init).inObjectScope(.container)
    DI.autoregister(AppStoreServiceType.self, initializer: MockAppStoreService.init).inObjectScope(.container)
  }
}
