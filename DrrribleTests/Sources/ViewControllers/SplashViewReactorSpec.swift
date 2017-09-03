//
//  SplashViewReactorSpec.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Nimble
import Quick
import Stubber

@testable import Drrrible

final class SplashViewReactorSpec: QuickSpec {
  override func spec() {
    super.spec()

    var userService: StubUserService!
    var reactor: SplashViewReactor!

    beforeEach {
      userService = StubUserService()
      reactor = SplashViewReactor(userService: userService)
      _ = reactor.state
    }

    describe("an initial state") {
      it("is not authenticated") {
        expect(reactor.currentState.isAuthenticated).to(beNil())
      }
    }

    describe("state.isAuthenticated") {
      context("when succeeds to fetch my profile") {
        it("is authenticated") {
          Stubber.register(userService.fetchMe) { .just(()) }
          reactor.action.onNext(.checkIfAuthenticated)
          expect(reactor.currentState.isAuthenticated) == true
        }
      }

      context("when fails to fetch my profile") {
        it("is not authenticated") {
          Stubber.register(userService.fetchMe) { .error(StubError()) }
          reactor.action.onNext(.checkIfAuthenticated)
          expect(reactor.currentState.isAuthenticated) == false
        }
      }
    }

    context("when receives a `.checkIfAuthenticated` action") {
      it("fetches my profile") {
        reactor.action.onNext(.checkIfAuthenticated)
        expect(Stubber.executions(userService.fetchMe).count) == 1
      }
    }
  }
}
