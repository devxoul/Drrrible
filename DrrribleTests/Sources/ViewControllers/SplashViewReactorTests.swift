//
//  SplashViewReactorTests.swift
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

final class SplashViewReactorTests: TestCase {
  func testIntialValue() {
    let reactor = SplashViewReactor(userService: StubUserService())
    XCTAssertEqual(reactor.currentState.isAuthenticated, nil)
  }

  func testFetchMeExecution() {
    let userService = StubUserService()
    Stubber.stub(userService.fetchMe) { .empty() }
    let reactor = SplashViewReactor(userService: userService)
    _ = reactor.state
    reactor.action.onNext(.checkIfAuthenticated)
    XCTAssertEqual(Stubber.executions(userService.fetchMe).count, 1)
  }

  func testIsAuthenticated_success() {
    let userService = StubUserService()
    Stubber.stub(userService.fetchMe) { .just() }
    let reactor = SplashViewReactor(userService: userService)
    _ = reactor.state
    reactor.action.onNext(.checkIfAuthenticated)
    XCTAssertEqual(reactor.currentState.isAuthenticated, true)
  }

  func testIsAuthenticated_failure() {
    let userService = StubUserService()
    Stubber.stub(userService.fetchMe) { .error(StubError()) }
    let reactor = SplashViewReactor(userService: userService)
    _ = reactor.state
    reactor.action.onNext(.checkIfAuthenticated)
    XCTAssertEqual(reactor.currentState.isAuthenticated, false)
  }
}
