//
//  ShotCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class ShotCellReactor: Reactor {
  typealias Action = NoAction

  struct State {
    var imageURL: URL
    var isAnimatedImage: Bool
  }

  let shot: Shot
  let initialState: State

  init(shot: Shot) {
    self.shot = shot
    self.initialState = State(
      imageURL: shot.imageURLs.normal,
      isAnimatedImage: shot.isAnimatedImage
    )
    _ = self.state
  }
}
