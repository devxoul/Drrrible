//
//  ShotViewReactionLikeButtonViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

final class ShotViewReactionLikeButtonViewReactor: ShotViewReactionButtonViewReactor {
  init(shot: Shot) {
    let initialState = State(
      shotID: shot.id,
      isReacted: shot.isLiked,
      canToggleReaction: shot.isLiked != nil,
      count: shot.likeCount
    )
    super.init(initialState: initialState)
  }

  override func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .toggleReaction:
      if self.currentState.isReacted != true {
        _ = self.shotService.like(shotID: self.shotID).subscribe()
      } else {
        _ = self.shotService.unlike(shotID: self.shotID).subscribe()
      }
      return .empty()
    }
  }

  override func mutation(from event: Shot.Event) -> Observable<Mutation> {
    switch event {
    case let .updateLiked(id, isLiked):
      guard id == self.shotID else { return .empty() }
      return Observable.from([.setReacted(isLiked), .setCanToggleReaction(true)])

    case let .increaseLikeCount(id):
      guard id == self.shotID else { return .empty() }
      return .just(.setCount(self.currentState.count + 1))

    case let .decreaseLikeCount(id):
      guard id == self.shotID else { return .empty() }
      return .just(.setCount(self.currentState.count - 1))
    }
  }
}
