//
//  LoginViewReactorTests.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest

import Nimble
import Quick
import Stubber

@testable import Drrrible

final class LoginViewReactorSpec: QuickSpec {
  override func spec() {
    var authService: StubAuthService!
    var userService: StubUserService!
    var reactor: LoginViewReactor!

    beforeEach {
      authService = StubAuthService()
      userService = StubUserService()
      reactor = LoginViewReactor(authService: authService, userService: userService)
      _ = reactor.state
    }

    describe("an initial state") {
      it("is not loading") {
        expect(reactor.currentState.isLoading) == false
      }

      it("is not logged in") {
        expect(reactor.currentState.isLoggedIn) == false
      }
    }

    context("when receives an action.login") {
      it("tries to login") {
        var identifiers: [String] = []
        Stubber.register(authService.authorize) {
          identifiers.append("authorize")
          return .just(())
        }
        Stubber.register(userService.fetchMe) {
          identifiers.append("fetchMe")
          return .just(())
        }
        reactor.action.onNext(.login)
        expect(Stubber.executions(authService.authorize).count) == 1
        expect(Stubber.executions(userService.fetchMe).count) == 1
        expect(identifiers) == ["authorize", "fetchMe"] // test method execution order
      }
    }

    describe("state.isLoading") {
      context("while authorizing") {
        it("is loading") {
          Stubber.register(authService.authorize) { .never() }
          reactor.action.onNext(.login)
          expect(reactor.currentState.isLoading) == true
        }
      }

      context("while fetching me") {
        it("is loading") {
          Stubber.register(userService.fetchMe) { .never() }
          reactor.action.onNext(.login)
          expect(reactor.currentState.isLoading) == true
        }
      }
    }

    describe("state.isLoggedIn") {
      context("when succeeds to authorize and fetch my profile") {
        it("is logged in") {
          Stubber.register(authService.authorize) { .just(()) }
          Stubber.register(userService.fetchMe) { .just(()) }
          reactor.action.onNext(.login)
          expect(reactor.currentState.isLoggedIn) == true
        }
      }

      context("when fails to authorize") {
        it("is not logged in") {
          Stubber.register(authService.authorize) { .error(StubError()) }
          Stubber.register(userService.fetchMe) { .just(()) }
          reactor.action.onNext(.login)
          expect(reactor.currentState.isLoggedIn) == false
        }
      }

      context("when fails to fetch my profile") {
        it("is not logged in") {
          Stubber.register(authService.authorize) { .just(()) }
          Stubber.register(userService.fetchMe) { .error(StubError()) }
          reactor.action.onNext(.login)
          expect(reactor.currentState.isLoggedIn) == false
        }
      }
    }
  }
}
