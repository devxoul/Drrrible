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

@testable import Drrrible

final class SplashViewReactorTests: TestCase {
  func testIntialValue() {
    let reactor = SplashViewReactor(userService: StubUserService())
    XCTAssertEqual(reactor.currentState.isAuthenticated, nil)
  }

  func testFetchMeExecution() {
    let userService = StubUserService().then {
      $0.stub($0.fetchMe) { .empty() }
    }
    let reactor = SplashViewReactor(userService: userService)
    _ = reactor.state
    reactor.action.onNext(.checkIfAuthenticated)
    XCTAssertEqual(userService.executions(userService.fetchMe).count, 1)
  }

  func testIsAuthenticated_success() {
    let userService = StubUserService().then {
      $0.stub($0.fetchMe) { .just() }
    }
    let reactor = SplashViewReactor(userService: userService)
    _ = reactor.state
    reactor.action.onNext(.checkIfAuthenticated)
    XCTAssertEqual(reactor.currentState.isAuthenticated, true)
  }

  func testIsAuthenticated_failure() {
    let userService = StubUserService().then {
      $0.stub($0.fetchMe) { .error(StubError()) }
    }
    let reactor = SplashViewReactor(userService: userService)
    _ = reactor.state
    reactor.action.onNext(.checkIfAuthenticated)
    XCTAssertEqual(reactor.currentState.isAuthenticated, false)
  }
}
