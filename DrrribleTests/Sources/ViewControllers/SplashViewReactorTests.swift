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

final class SplashViewReactorTests: XCTestCase {

  func testIsAuthenticated() {
    RxExpect("it should set isAuthenticated false when not authenticated") { test in
      let provider = MockServiceProvider()
      provider.userService = MockUserService(provider: provider).then {
        $0.fetchMeClosure = { Observable.error(MockError()) }
      }
      let reactor = SplashViewReactor(provider: provider)

      // input
      test.input(reactor.action, [
        next(100, .checkIfAuthenticated),
      ])

      // assert
      test.assert(reactor.state.map { $0.isAuthenticated }.distinctUntilChanged())
        .filterNext()
        .equal([nil, false]) { $0 == $1 }
    }

    RxExpect("it should set isAuthenticated true when not authenticated") { test in
      let provider = MockServiceProvider()
      let reactor = SplashViewReactor(provider: provider)
      test.input(reactor.action, [
        next(100, .checkIfAuthenticated),
      ])
      test.assert(reactor.state.map { $0.isAuthenticated }.distinctUntilChanged())
        .filterNext()
        .equal([nil, true]) { $0 == $1 }
    }
  }

}
