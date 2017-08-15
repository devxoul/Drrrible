//
//  ShotViewImageCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class ShotViewImageCellReactor: Reactor {
  typealias Action = NoAction
  
  struct State {
    var imageURL: URL
  }

  let initialState: State

  init(shot: Shot) {
    self.initialState = State(imageURL: shot.imageURLs.hidpi ?? shot.imageURLs.normal)
    _ = self.state
  }
}
