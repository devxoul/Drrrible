//
//  SplashViewControllerTests.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 22/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest
@testable import Drrrible

final class SplashViewControllerTests: TestCase {
  func testAction_checkIfAuthenticated() {
    let reactor = SplashViewReactor(userService: StubUserService())
    reactor.stub.isEnabled = true
    let viewController = SplashViewController(
      reactor: reactor,
      presentLoginScreen: {},
      presentMainScreen: {}
    )
    _ = viewController.view
    viewController.viewDidAppear(false)
    XCTAssertTrue({
      if case .checkIfAuthenticated = reactor.stub.actions.last! {
        return true
      } else {
        return false
      }
    }())
  }

  func testExecution_presentLoginScreen() {
    var isExecuted: (presentLoginScreen: Bool, presentMainScreen: Bool) = (false, false)
    let reactor = SplashViewReactor(userService: StubUserService())
    reactor.stub.isEnabled = true
    let viewController = SplashViewController(
      reactor: reactor,
      presentLoginScreen: { isExecuted.presentLoginScreen = true },
      presentMainScreen: { isExecuted.presentMainScreen = true }
    )
    _ = viewController.view
    reactor.stub.state.value.isAuthenticated = false
    XCTAssertEqual(isExecuted.presentLoginScreen, true)
    XCTAssertEqual(isExecuted.presentMainScreen, false)
  }

  func testExecution_presentMainScreen() {
    var isExecuted: (presentLoginScreen: Bool, presentMainScreen: Bool) = (false, false)
    let reactor = SplashViewReactor(userService: StubUserService())
    reactor.stub.isEnabled = true
    let viewController = SplashViewController(
      reactor: reactor,
      presentLoginScreen: { isExecuted.presentLoginScreen = true },
      presentMainScreen: { isExecuted.presentMainScreen = true }
    )
    _ = viewController.view
    reactor.stub.state.value.isAuthenticated = true
    XCTAssertEqual(isExecuted.presentLoginScreen, false)
    XCTAssertEqual(isExecuted.presentMainScreen, true)
  }
}
