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

    init(imageURL: URL) {
      self.imageURL = imageURL
    }
  }

  let provider: ServiceProviderType
  let shot: Shot
  let initialState: State

  init(provider: ServiceProviderType, shot: Shot) {
    self.provider = provider
    self.shot = shot
    self.initialState = State(imageURL: shot.imageURLs.teaser)
  }
}
