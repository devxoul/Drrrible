//
//  ShotViewReactionCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

import ReactorKit

final class ShotViewReactionCellReactor: Reactor {
  typealias Action = NoAction

  let initialState: Void = Void()
  let likeButtonViewReactor: ShotViewReactionButtonViewReactor
  let commentButtonViewReactor: ShotViewReactionButtonViewReactor

  init(
    shot: Shot,
    likeButtonViewReactorFactory: (Shot) -> ShotViewReactionLikeButtonViewReactor,
    commentButtonViewReactorFactory: (Shot) -> ShotViewReactionCommentButtonViewReactor
  ) {
    self.likeButtonViewReactor = likeButtonViewReactorFactory(shot)
    self.commentButtonViewReactor = commentButtonViewReactorFactory(shot)
    _ = self.state
  }
}
