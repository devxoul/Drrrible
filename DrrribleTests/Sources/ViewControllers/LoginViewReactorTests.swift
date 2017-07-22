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
/*
final class LoginViewReactorTests: TestCase {
  func testIsLoading() {
    RxExpect("it should change isLoading when start login") { test in
      // Environment
      DI.register(AuthServiceType.self) { _ in
        MockAuthService().then {
          $0.authorizeClosure = { Observable.just(Void()) }
        }
      }
      DI.register(UserServiceType.self) { _ in
        MockUserService().then {
          $0.fetchMeClosure = { Observable.just(Void()) }
        }
      }
      let reactor = LoginViewReactor()

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
      DI.register(AuthServiceType.self) { _ in
        MockAuthService().then {
          $0.authorizeClosure = { Observable.just(Void()) }
        }
      }
      DI.register(UserServiceType.self) { _ in
        MockUserService().then {
          $0.fetchMeClosure = { Observable.just(Void()) }
        }
      }
      let reactor = LoginViewReactor()

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
      DI.register(AuthServiceType.self) { _ in
        MockAuthService().then {
          $0.authorizeClosure = { .error(MockError()) }
        }
      }
      DI.register(UserServiceType.self) { _ in
        MockUserService().then {
          $0.fetchMeClosure = { Observable.just(Void()) }
        }
      }
      let reactor = LoginViewReactor()

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
      DI.register(AuthServiceType.self) { _ in
        MockAuthService().then {
          $0.authorizeClosure = { .just(Void()) }
        }
      }
      DI.register(UserServiceType.self) { _ in
        MockUserService().then {
          $0.fetchMeClosure = { .error(MockError()) }
        }
      }
      let reactor = LoginViewReactor()

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
*/
