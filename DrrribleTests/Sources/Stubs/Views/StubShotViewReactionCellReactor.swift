//
//  StubShotViewReactionCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 20/08/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

extension ShotViewReactionCellReactor {
  static func stub(
    shot: Shot,
    likeButtonViewReactorFactory: ((Shot) -> ShotViewReactionLikeButtonViewReactor)? = nil,
    commentButtonViewReactorFactory: ((Shot) -> ShotViewReactionCommentButtonViewReactor)? = nil
  ) -> ShotViewReactionCellReactor {
    return .init(
      shot: shot,
      likeButtonViewReactorFactory: likeButtonViewReactorFactory ?? { shot in
        ShotViewReactionLikeButtonViewReactor(
          shot: shot,
          shotService: StubShotService(),
          analytics: .stub()
        )
      },
      commentButtonViewReactorFactory: commentButtonViewReactorFactory ?? { shot in
        ShotViewReactionCommentButtonViewReactor(shot: shot)
      }
    )
  }
}
