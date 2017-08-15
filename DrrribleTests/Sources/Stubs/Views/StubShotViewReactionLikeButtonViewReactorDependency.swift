//
//  StubShotViewReactionLikeButtonViewReactorDependency.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 16/08/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

extension ShotViewReactionLikeButtonViewReactor.Dependency {
  static func stub(
    shotService: ShotServiceType? = nil,
    analytics: DrrribleAnalytics? = nil
  ) -> ShotViewReactionLikeButtonViewReactor.Dependency {
    return .init(
      shotService: shotService ?? StubShotService(),
      analytics: analytics ?? StubAnalytics()
    )
  }
}
