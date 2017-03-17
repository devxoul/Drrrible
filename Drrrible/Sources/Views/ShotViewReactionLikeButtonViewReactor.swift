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

  let didDeallocate: PublishSubject<Void> = .init()
  let buttonDidTap: PublishSubject<Void> = .init()


  // MARK: Output

  let isButtonSelected: Bool
  let isButtonUserInteractionEnabled: Bool
  let labelText: String


  // MARK: Initializing

  init(provider: ServiceProviderType, shot: Shot) {
    self.isButtonSelected = shot.isLiked ?? false
    self.isButtonUserInteractionEnabled = (shot.isLiked != nil)
    self.labelText = "\(shot.likeCount)"

    _ = self.buttonDidTap
      .filter { shot.isLiked == false }
      .do(onNext: { Shot.event.onNext(.like(id: shot.id)) })
      .flatMap { provider.shotService.like(shotID: shot.id).ignoreErrors() }
      .takeUntil(self.didDeallocate)
      .subscribe()

    _ = self.buttonDidTap
      .filter { shot.isLiked == true }
      .do(onNext: { Shot.event.onNext(.unlike(id: shot.id)) })
      .flatMap { provider.shotService.like(shotID: shot.id).ignoreErrors() }
      .takeUntil(self.didDeallocate)
      .subscribe()
  }

}
