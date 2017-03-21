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

  func testPresentLoginScreen() {
    RxExpect("it should present login screen when not authenticated") { test in
      let provider = MockServiceProvider()
      provider.userService = MockUserService(provider: provider).then {
        $0.fetchMeClosure = { Observable.error(MockError()) }
      }
      let reactor = SplashViewReactor(provider: provider)
      test.input(reactor.checkIfAuthenticated, [
        next(100, Void()),
      ])
      test.assert(reactor.presentLoginScreen.map(true))
        .filterNext()
        .equal([true])
    }
  }

  func testPresentMainScreen() {
    RxExpect("it should present main screen when authenticated") { test in
      let provider = MockServiceProvider()
      let reactor = SplashViewReactor(provider: provider)
      test.input(reactor.checkIfAuthenticated, [
        next(100, Void()),
      ])
      test.assert(reactor.presentMainScreen.map(true))
        .filterNext()
        .equal([true])
    }
  }

}
