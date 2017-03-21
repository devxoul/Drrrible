//
//  ShotViewReactionCommentButtonViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

final class ShotViewReactionCommentButtonViewReactor: ShotViewReactionButtonViewReactorType {

  // MARK: Input

  let dispose: PublishSubject<Void> = .init()
  let toggleReaction: PublishSubject<Void> = .init()


  // MARK: Output

  let isReacted: Bool
  let canToggleReaction: Bool
  let text: String


  // MARK: Initializing

  init(provider: ServiceProviderType, shot: Shot) {
    self.isReacted = false
    self.canToggleReaction = true
    self.text = "\(shot.commentCount)"
  }

}
