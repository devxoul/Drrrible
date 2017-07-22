//
//  LoginViewReactorTests.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest

import RxCocoa
import RxExpect
import RxSwift
import RxTest

@testable import Drrrible

final class LoginViewReactorTests: TestCase {
  func testInitialState() {
    let reactor = LoginViewReactor(
      authService: StubAuthService(),
      userService: StubUserService()
    )
    XCTAssertEqual(reactor.currentState.isLoading, false)
    XCTAssertEqual(reactor.currentState.isLoggedIn, false)
  }

  func testExecution_serviceMethods() {
    var identifiers: [String] = []
    let authService = StubAuthService().then {
      $0.stub($0.authorize) {
        identifiers.append("authorize")
        return .just()
      }
    }
    let userService = StubUserService().then {
      $0.stub($0.fetchMe) {
        identifiers.append("fetchMe")
        return .just()
      }
    }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(authService.executions(authService.authorize).count, 1)
    XCTAssertEqual(userService.executions(userService.fetchMe).count, 1)
    XCTAssertEqual(identifiers, ["authorize", "fetchMe"]) // test method call order
  }

  func testState_isLoading_true_whileAuthorizing() {
    let authService = StubAuthService().then {
      $0.stub($0.authorize) { .never() }
    }
    let userService = StubUserService().then {
      $0.stub($0.fetchMe) { .empty() }
    }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoading, true)
  }

  func testState_isLoading_true_whileFetchingMe() {
    let authService = StubAuthService().then {
      $0.stub($0.authorize) { .just() }
    }
    let userService = StubUserService().then {
      $0.stub($0.fetchMe) { .never() }
    }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoading, true)
  }

  func testState_isLoggedIn_true() {
    let authService = StubAuthService().then {
      $0.stub($0.authorize) { .just() }
    }
    let userService = StubUserService().then {
      $0.stub($0.fetchMe) { .just() }
    }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoggedIn, true)
  }

  func testState_isLoggedIn_false_authorizeFailure() {
    let authService = StubAuthService().then {
      $0.stub($0.authorize) { .error(StubError()) }
    }
    let userService = StubUserService().then {
      $0.stub($0.fetchMe) { .just() }
    }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoggedIn, false)
  }

  func testState_isLoggedIn_false_fetchMeFailure() {
    let authService = StubAuthService().then {
      $0.stub($0.authorize) { .just() }
    }
    let userService = StubUserService().then {
      $0.stub($0.fetchMe) { .error(StubError()) }
    }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoggedIn, false)
  }
}
