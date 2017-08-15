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

  struct Dependency {
    let likeButtonViewReactorFactory: (Shot) -> ShotViewReactionLikeButtonViewReactor
    let commentButtonViewReactorFactory: (Shot) -> ShotViewReactionCommentButtonViewReactor
  }

  fileprivate let dependency: Dependency
  let initialState: Void = Void()
  let likeButtonViewReactor: ShotViewReactionButtonViewReactor
  let commentButtonViewReactor: ShotViewReactionButtonViewReactor

  init(shot: Shot, dependency: Dependency) {
    self.dependency = dependency
    self.likeButtonViewReactor = dependency.likeButtonViewReactorFactory(shot)
    self.commentButtonViewReactor = dependency.commentButtonViewReactorFactory(shot)
    _ = self.state
  }
}
