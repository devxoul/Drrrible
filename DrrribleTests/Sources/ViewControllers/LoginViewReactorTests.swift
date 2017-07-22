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
      authService: MockAuthService(),
      userService: MockUserService()
    )
    XCTAssertEqual(reactor.currentState.isLoading, false)
    XCTAssertEqual(reactor.currentState.isLoggedIn, false)
  }

  func testExecution_serviceMethods() {
    var identifiers: [String] = []
    let authService = MockAuthService()
    authService.mock(MockAuthService.authorize) {
      identifiers.append("authorize")
      return .just()
    }
    let userService = MockUserService()
    userService.mock(MockUserService.fetchMe) {
      identifiers.append("fetchMe")
      return .just()
    }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(authService.executionCount(MockAuthService.authorize), 1)
    XCTAssertEqual(userService.executionCount(MockUserService.fetchMe), 1)
    XCTAssertEqual(identifiers, ["authorize", "fetchMe"]) // test method call order
  }

  func testState_isLoading_true_whileAuthorizing() {
    let authService = MockAuthService()
    authService.mock(MockAuthService.authorize) { .never() }
    let userService = MockUserService()
    userService.mock(MockUserService.fetchMe) { .empty() }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoading, true)
  }

  func testState_isLoading_true_whileFetchingMe() {
    let authService = MockAuthService()
    authService.mock(MockAuthService.authorize) { .just() }
    let userService = MockUserService()
    userService.mock(MockUserService.fetchMe) { .never() }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoading, true)
  }

  func testState_isLoggedIn_true() {
    let authService = MockAuthService()
    authService.mock(MockAuthService.authorize) { .just() }
    let userService = MockUserService()
    userService.mock(MockUserService.fetchMe) { .just() }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoggedIn, true)
  }

  func testState_isLoggedIn_false_authorizeFailure() {
    let authService = MockAuthService()
    authService.mock(MockAuthService.authorize) { .error(MockError()) }
    let userService = MockUserService()
    userService.mock(MockUserService.fetchMe) { .just() }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoggedIn, false)
  }

  func testState_isLoggedIn_false_fetchMeFailure() {
    let authService = MockAuthService()
    authService.mock(MockAuthService.authorize) { .just() }
    let userService = MockUserService()
    userService.mock(MockUserService.fetchMe) { .error(MockError()) }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoggedIn, false)
  }
}
