//
//  StubLoginViewControllerDependency.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 15/08/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

extension LoginViewController.Dependency {
  static func stub(
    analytics: DrrribleAnalytics? = nil,
    presentMainScreen: (() -> Void)? = nil
  ) -> LoginViewController.Dependency {
    return .init(
      analytics: analytics ?? StubAnalytics(),
      presentMainScreen: presentMainScreen ?? {}
    )
  }
}
