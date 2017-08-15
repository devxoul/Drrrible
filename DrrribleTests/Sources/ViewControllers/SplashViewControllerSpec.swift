//
//  SplashViewControllerSpec.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 22/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Nimble
import Quick
@testable import Drrrible

final class SplashViewControllerSpec: QuickSpec {
  override func spec() {
    describe("a view") {
      context("when did appear") {
        it("sends a `.checkIfAuthenticated` action to the reactor") {
          let reactor = SplashViewReactor(userService: StubUserService())
          reactor.stub.isEnabled = true
          let viewController = SplashViewController(
            reactor: reactor,
            presentLoginScreen: {},
            presentMainScreen: {}
          )
          _ = viewController.view
          viewController.viewDidAppear(false)
          expect(reactor.stub.actions.last).to(match) {
            if case .checkIfAuthenticated = $0 {
              return true
            } else {
              return false
            }
          }
        }
      }
    }

    describe("a navigation") {
      var isExecuted: (presentLoginScreen: Bool, presentMainScreen: Bool)!
      var reactor: SplashViewReactor!
      var viewController: SplashViewController!

      beforeEach {
        isExecuted = (false, false)
        reactor = SplashViewReactor(userService: StubUserService())
        reactor.stub.isEnabled = true
        viewController = SplashViewController(
          reactor: reactor,
          presentLoginScreen: { isExecuted.presentLoginScreen = true },
          presentMainScreen: { isExecuted.presentMainScreen = true }
        )
        _ = viewController.view
      }

      context("when succeeds to authenticate") {
        beforeEach {
          reactor.stub.state.value.isAuthenticated = true
        }
        it("doesn't present login screen") {
          expect(isExecuted.presentLoginScreen) == false
        }
        it("presents main screen") {
          expect(isExecuted.presentMainScreen) == true
        }
      }

      context("when fails to authenticate") {
        beforeEach {
          reactor.stub.state.value.isAuthenticated = false
        }
        it("presents login screen") {
          expect(isExecuted.presentLoginScreen) == true
        }
        it("doesn't present main screen") {
          expect(isExecuted.presentMainScreen) == false
        }
      }
    }
  }
}
