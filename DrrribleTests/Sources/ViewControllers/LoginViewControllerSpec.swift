//
//  LoginViewControllerSpec.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 22/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Nimble
import Quick
@testable import Drrrible

final class LoginViewControllerSpec: QuickSpec {
  override func spec() {
    var authService: StubAuthService!
    var userService: StubUserService!

    beforeEach {
      authService = StubAuthService()
      userService = StubUserService()
    }

    describe("action.login") {
      var reactor: LoginViewReactor!
      var viewController: LoginViewController!

      beforeEach {
        reactor = LoginViewReactor(authService: authService, userService: userService)
        reactor.stub.isEnabled = true
        viewController = LoginViewController(
          reactor: reactor,
          analytics: .stub(),
          presentMainScreen: {}
        )
        _ = viewController.view
      }

      context("when a login button tapped") {
        it("sends `.login` action to the reactor") {
          viewController.loginButton.sendActions(for: .touchUpInside)
          expect(reactor.stub.actions.last).to(match) {
            if case .login = $0 {
              return true
            } else {
              return false
            }
          }
        }
      }
    }

    describe("state.isLoading") {
      var reactor: LoginViewReactor!
      var viewController: LoginViewController!

      beforeEach {
        reactor = LoginViewReactor(authService: authService, userService: userService)
        reactor.stub.isEnabled = true
        viewController = LoginViewController(
          reactor: reactor,
          analytics: .stub(),
          presentMainScreen: {}
        )
        _ = viewController.view
      }

      context("is not loading") {
        beforeEach {
          reactor.stub.state.value.isLoading = false
        }

        describe("a login button") {
          it("is not hidden") {
            expect(viewController.loginButton.isHidden) == false
          }
        }

        describe("an activity indicator view") {
          it("is not animating") {
            expect(viewController.activityIndicatorView.isAnimating) == false
          }
        }
      }

      context("is loading") {
        beforeEach {
          reactor.stub.state.value.isLoading = true
        }

        describe("a login button") {
          it("is hidden") {
            expect(viewController.loginButton.isHidden) == true
          }
        }

        describe("an activity indicator view") {
          it("is animating") {
            expect(viewController.activityIndicatorView.isAnimating) == true
          }
        }
      }
    }

    describe("state.isLoggedIn") {
      var reactor: LoginViewReactor!
      var viewController: LoginViewController!
      var isPresentMainScreenExecuted: Bool!

      beforeEach {
        reactor = LoginViewReactor(authService: authService, userService: userService)
        reactor.stub.isEnabled = true
        isPresentMainScreenExecuted = false
        viewController = LoginViewController(
          reactor: reactor,
          analytics: StubAnalytics(),
          presentMainScreen: { isPresentMainScreenExecuted = true }
        )
        _ = viewController.view
      }

      context("when logged in") {
        beforeEach {
          reactor.stub.state.value.isLoggedIn = true
        }

        it("presents main screen") {
          expect(isPresentMainScreenExecuted) == true
        }
      }

      context("when not logged in") {
        beforeEach {
          reactor.stub.state.value.isLoggedIn = false
        }

        it("presents main screen") {
          expect(isPresentMainScreenExecuted) == false
        }
      }
    }

    describe("an analytics") {
      var analytics: StubAnalytics!
      var reactor: LoginViewReactor!
      var viewController: LoginViewController!

      beforeEach {
        analytics = StubAnalytics()
        reactor = LoginViewReactor(authService: authService, userService: userService)
        reactor.stub.isEnabled = true
        viewController = LoginViewController(
          reactor: reactor,
          analytics: analytics,
          presentMainScreen: {}
        )
        _ = viewController.view
      }

      context("when a login button is tapped") {
        it("logs a try login event") {
          viewController.loginButton.sendActions(for: .touchUpInside)
          expect(analytics.events.last).to(match) {
            if case .tryLogin = $0 {
              return true
            } else {
              return false
            }
          }
        }
      }

      context("when succeeds to login") {
        it("logs a login event") {
          reactor.stub.state.value.isLoggedIn = true
          expect(analytics.events.last).to(match) {
            if case .login = $0 {
              return true
            } else {
              return false
            }
          }
        }
      }
    }
  }
}
