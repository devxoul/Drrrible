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
  fileprivate let provider: ServiceProviderType
  fileprivate let shot: Shot

  init(provider: ServiceProviderType, shot: Shot) {
    self.provider = provider
    self.shot = shot
    let initialState = State(
      isReacted: shot.isLiked ?? false,
      canToggleReaction: shot.isLiked != nil,
      text: "\(shot.likeCount)"
    )
    super.init(initialState: initialState)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .toggleReaction:
      if self.shot.isLiked == false {
        Shot.event.onNext(.like(id: shot.id))
        _ = self.provider.shotService.like(shotID: self.shot.id).subscribe()
      } else if self.shot.isLiked == true {
        Shot.event.onNext(.unlike(id: shot.id))
        _ = self.provider.shotService.unlike(shotID: self.shot.id).subscribe()
      }
      return .empty()

    case let .shotEvent(event):
      switch event {
      case let .like(id):
        guard id == self.shot.id else { return .empty() }
        return .just(.setReacted(true))

      case let .unlike(id):
        guard id == self.shot.id else { return .empty() }
        return .just(.setReacted(false))

      default:
        return .empty()
      }
    }
  }
}
