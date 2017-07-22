//
//  LoginViewControllerTests.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 22/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest
@testable import Drrrible

final class LoginViewControllerTests: TestCase {
  func testAction_login() {
    let reactor = LoginViewReactor(authService: MockAuthService(), userService: MockUserService())
    reactor.stub.isEnabled = true
    let viewController = LoginViewController(reactor: reactor, presentMainScreen: {})
    viewController.loginButton.sendActions(for: .touchUpInside)
    XCTAssertTrue({
      if case .login = reactor.stub.actions.last! {
        return true
      } else {
        return false
      }
    }())
  }

  func testState_isLoading() {
    let reactor = LoginViewReactor(authService: MockAuthService(), userService: MockUserService())
    reactor.stub.isEnabled = true
    let viewController = LoginViewController(reactor: reactor, presentMainScreen: {})
    XCTAssertEqual(viewController.loginButton.isHidden, false)
    XCTAssertEqual(viewController.activityIndicatorView.isAnimating, false)
    reactor.stub.state.value.isLoading = true
    XCTAssertEqual(viewController.loginButton.isHidden, true)
    XCTAssertEqual(viewController.activityIndicatorView.isAnimating, true)
  }

  func testState_isLoggedIn_true() {
    let reactor = LoginViewReactor(authService: MockAuthService(), userService: MockUserService())
    reactor.stub.isEnabled = true
    var isPresentMainScreenExecuted = false
    let viewController = LoginViewController(
      reactor: reactor,
      presentMainScreen: { isPresentMainScreenExecuted = true }
    )
    _ = viewController
    reactor.stub.state.value.isLoggedIn = true
    XCTAssertEqual(isPresentMainScreenExecuted, true)
  }

  func testState_isLoggedIn_false() {
    let reactor = LoginViewReactor(authService: MockAuthService(), userService: MockUserService())
    reactor.stub.isEnabled = true
    var isPresentMainScreenExecuted = false
    let viewController = LoginViewController(
      reactor: reactor,
      presentMainScreen: { isPresentMainScreenExecuted = true }
    )
    _ = viewController
    reactor.stub.state.value.isLoggedIn = false
    XCTAssertEqual(isPresentMainScreenExecuted, false)
  }
}
