//
//  StubShotViewReactionCellReactorDependency.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 16/08/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

extension ShotViewReactionCellReactor.Dependency {
  static func stub(
    likeButtonViewReactorFactory: ((Shot) -> ShotViewReactionLikeButtonViewReactor)? = nil,
    commentButtonViewReactorFactory: ((Shot) -> ShotViewReactionCommentButtonViewReactor)? = nil
  ) -> ShotViewReactionCellReactor.Dependency {
    return .init(
      likeButtonViewReactorFactory: likeButtonViewReactorFactory ?? { shot in
        ShotViewReactionLikeButtonViewReactor(shot: shot, dependency: .stub())
      },
      commentButtonViewReactorFactory: commentButtonViewReactorFactory ?? { shot in
        ShotViewReactionCommentButtonViewReactor(shot: shot)
      }
    )
  }
}
