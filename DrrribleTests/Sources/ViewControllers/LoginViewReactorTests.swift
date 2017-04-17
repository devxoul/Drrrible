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

      // Input
      test.input(reactor.action, [
        next(100, .login),
      ])

      // Output
      test.assert(reactor.state.map { $0.isLoading }.distinctUntilChanged())
        .filterNext()
        .equal([false, true])
    }
  }

  func testIsLoggedIn() {
    RxExpect("it should set isLoggedIn true when authorize() and fetchMe() succeeds") { test in
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
      test.input(reactor.action, [
        next(100, .login),
      ])

      // Output
      test.assert(reactor.state.map { $0.isLoggedIn }.distinctUntilChanged())
        .filterNext()
        .equal([false, true])
    }

    RxExpect("it should not isLoggedIn false when authorize() fails") { test in
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
      test.input(reactor.action, [
        next(100, .login),
      ])

      // Output
      test.assert(reactor.state.map { $0.isLoggedIn }.distinctUntilChanged())
        .filterNext()
        .equal([false])
    }

    RxExpect("it should set isLoggedIn false when fetchMe() fails") { test in
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
      test.input(reactor.action, [
        next(100, .login),
      ])

      // Output
      test.assert(reactor.state.map { $0.isLoggedIn }.distinctUntilChanged())
        .filterNext()
        .equal([false])
    }
  }

}
