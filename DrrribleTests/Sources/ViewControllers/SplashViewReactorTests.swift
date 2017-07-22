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
    let reactor = SplashViewReactor(userService: MockUserService())
    XCTAssertEqual(reactor.currentState.isAuthenticated, nil)
  }

  func testFetchMeExecution() {
    let userService = MockUserService()
    userService.mock(MockUserService.fetchMe) {
      return .empty()
    }
    let reactor = SplashViewReactor(userService: userService)
    _ = reactor.state
    reactor.action.onNext(.checkIfAuthenticated)
    XCTAssertEqual(userService.executionCount(MockUserService.fetchMe), 1)
  }

  func testIsAuthenticated_success() {
    let userService = MockUserService()
    userService.mock(MockUserService.fetchMe) {
      return .just()
    }
    let reactor = SplashViewReactor(userService: userService)
    _ = reactor.state
    reactor.action.onNext(.checkIfAuthenticated)
    XCTAssertEqual(reactor.currentState.isAuthenticated, true)
  }

  func testIsAuthenticated_failure() {
    let userService = MockUserService()
    userService.mock(MockUserService.fetchMe) {
      return .error(MockError())
    }
    let reactor = SplashViewReactor(userService: userService)
    _ = reactor.state
    reactor.action.onNext(.checkIfAuthenticated)
    XCTAssertEqual(reactor.currentState.isAuthenticated, false)
  }
}
