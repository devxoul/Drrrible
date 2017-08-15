//
//  ShotViewReactorDependency.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 16/08/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

extension ShotViewReactor.Dependency {
  static func stub(
    shotService: ShotServiceType? = nil,
    reactionCellReactorFactory: ((Shot) -> ShotViewReactionCellReactor)? = nil
  ) -> ShotViewReactor.Dependency {
    return .init(
      shotService: shotService ?? StubShotService(),
      reactionCellReactorFactory: reactionCellReactorFactory ?? { shot in
        ShotViewReactionCellReactor(shot: shot, dependency: .stub())
      }
    )
  }
}
