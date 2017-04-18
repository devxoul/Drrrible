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

  fileprivate let provider: ServiceProviderType
  let initialState: State

  init(provider: ServiceProviderType, shot: Shot) {
    self.provider = provider
    self.initialState = State(imageURL: shot.imageURLs.hidpi ?? shot.imageURLs.normal)
  }
}
