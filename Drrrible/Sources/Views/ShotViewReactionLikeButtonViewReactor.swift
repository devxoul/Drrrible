//
//  ShotViewReactionLikeButtonViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

final class ShotViewReactionLikeButtonViewReactor: ShotViewReactionButtonViewReactorType {

  // MARK: Input

  let dispose: PublishSubject<Void> = .init()
  let toggleReaction: PublishSubject<Void> = .init()


  // MARK: Output

  let isReacted: Bool
  let canToggleReaction: Bool
  let text: String


  // MARK: Initializing

  init(provider: ServiceProviderType, shot: Shot) {
    self.isReacted = shot.isLiked ?? false
    self.canToggleReaction = (shot.isLiked != nil)
    self.text = "\(shot.likeCount)"

    _ = self.toggleReaction
      .filter { shot.isLiked == false }
      .do(onNext: { Shot.event.onNext(.like(id: shot.id)) })
      .flatMap { provider.shotService.like(shotID: shot.id).ignoreErrors() }
      .takeUntil(self.dispose)
      .subscribe()

    _ = self.toggleReaction
      .filter { shot.isLiked == true }
      .do(onNext: { Shot.event.onNext(.unlike(id: shot.id)) })
      .flatMap { provider.shotService.unlike(shotID: shot.id).ignoreErrors() }
      .takeUntil(self.dispose)
      .subscribe()
  }

}
