//
//  ShotViewReactionCommentButtonViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

final class ShotViewReactionCommentButtonViewReactor: ShotViewReactionButtonViewReactor {
  fileprivate let shot: Shot

  init(shot: Shot) {
    self.shot = shot
    let initialState = State(
      shotID: shot.id,
      isReacted: false,
      canToggleReaction: true,
      count: shot.commentCount
    )
    super.init(initialState: initialState)
  }
}
