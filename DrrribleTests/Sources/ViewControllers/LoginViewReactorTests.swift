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

final class LoginViewReactorTests: XCTestCase {

  func testIsLoading() {
    RxExpect("is should change isLoading when start login") { test in
      // Environment
      let provider = MockServiceProvider()
      provider.authService = MockAuthService(provider: provider).then {
        $0.authorizeClosure = { Observable.just(Void()) }
      }
      provider.userService = MockUserService(provider: provider).then {
        $0.fetchMeClosure = { Observable.just(Void()) }
      }
      let reactor = LoginViewReactor(provider: provider)
      reactor.presentMainScreen.subscribe().addDisposableTo(test.disposeBag)

      // Input
      test.input(reactor.login, [
        next(100, Void()),
      ])

      // Output
      test.assert(reactor.isLoading)
        .filterNext()
        .equal([false, true, false])
    }
  }

  func testPresentMainScreen() {
    RxExpect("it should present main screen when authorize() and fetchMe() succeeds") { test in
      // Environment
      let provider = MockServiceProvider()
      provider.authService = MockAuthService(provider: provider).then {
        $0.authorizeClosure = { Observable.just(Void()) }
      }
      provider.userService = MockUserService(provider: provider).then {
        $0.fetchMeClosure = { Observable.just(Void()) }
      }
      let reactor = LoginViewReactor(provider: provider)

      // Input
      test.input(reactor.login, [
        next(100, Void()),
      ])

      // Output
      test.assert(reactor.presentMainScreen)
        .filterNext()
        .not()
        .isEmpty()
    }

    RxExpect("it should not present main screen when authorize() fails") { test in
      // Environment
      let provider = MockServiceProvider()
      provider.authService = MockAuthService(provider: provider).then {
        $0.authorizeClosure = { .error(MockError()) }
      }
      provider.userService = MockUserService(provider: provider).then {
        $0.fetchMeClosure = { Observable.just(Void()) }
      }
      let reactor = LoginViewReactor(provider: provider)

      // Input
      test.input(reactor.login, [
        next(100, Void()),
      ])

      // Output
      test.assert(reactor.presentMainScreen)
        .filterNext()
        .isEmpty()
    }

    RxExpect("it should not present main screen when fetchMe() fails") { test in
      // Environment
      let provider = MockServiceProvider()
      provider.authService = MockAuthService(provider: provider).then {
        $0.authorizeClosure = { .just(Void()) }
      }
      provider.userService = MockUserService(provider: provider).then {
        $0.fetchMeClosure = { .error(MockError()) }
      }
      let reactor = LoginViewReactor(provider: provider)

      // Input
      test.input(reactor.login, [
        next(100, Void()),
      ])

      // Output
      test.assert(reactor.presentMainScreen)
        .filterNext()
        .isEmpty()
    }
  }

}
