//
//  ShotViewReactionButtonViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

enum ShotReactionType {
  case like
}

protocol ShotViewReactionButtonViewReactorType {
  // Input
  var dispose: PublishSubject<Void> { get }
  var toggleReaction: PublishSubject<Void> { get }

  // Output
  var isReacted: Bool { get }
  var canToggleReaction: Bool { get }
  var text: String { get }
}
