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
import Stubber

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
    let authService = StubAuthService()
    let userService = StubUserService()
    Stubber.stub(authService.authorize) {
      identifiers.append("authorize")
      return .just()
    }
    Stubber.stub(userService.fetchMe) {
      identifiers.append("fetchMe")
      return .just()
    }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(Stubber.executions(authService.authorize).count, 1)
    XCTAssertEqual(Stubber.executions(userService.fetchMe).count, 1)
    XCTAssertEqual(identifiers, ["authorize", "fetchMe"]) // test method call order
  }

  func testState_isLoading_true_whileAuthorizing() {
    let authService = StubAuthService()
    let userService = StubUserService()
    Stubber.stub(authService.authorize) { .never() }
    Stubber.stub(userService.fetchMe) { .empty() }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoading, true)
  }

  func testState_isLoading_true_whileFetchingMe() {
    let authService = StubAuthService()
    let userService = StubUserService()
    Stubber.stub(authService.authorize) { .just() }
    Stubber.stub(userService.fetchMe) { .never() }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoading, true)
  }

  func testState_isLoggedIn_true() {
    let authService = StubAuthService()
    let userService = StubUserService()
    Stubber.stub(authService.authorize) { .just() }
    Stubber.stub(userService.fetchMe) { .just() }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoggedIn, true)
  }

  func testState_isLoggedIn_false_authorizeFailure() {
    let authService = StubAuthService()
    let userService = StubUserService()
    Stubber.stub(authService.authorize) { .error(StubError()) }
    Stubber.stub(userService.fetchMe) { .just() }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoggedIn, false)
  }

  func testState_isLoggedIn_false_fetchMeFailure() {
    let authService = StubAuthService()
    let userService = StubUserService()
    Stubber.stub(authService.authorize) { .just() }
    Stubber.stub(userService.fetchMe) { .error(StubError()) }
    let reactor = LoginViewReactor(
      authService: authService,
      userService: userService
    )
    _ = reactor.state
    reactor.action.onNext(.login)
    XCTAssertEqual(reactor.currentState.isLoggedIn, false)
  }
}
