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
  enum Action {
    case showShot
  }

  struct State {
    var imageURL: URL
    var navigation: Navigation?

    init(imageURL: URL) {
      self.imageURL = imageURL
    }
  }

  enum Navigation {
    case shot(ShotViewReactor)
  }

  fileprivate let provider: ServiceProviderType
  fileprivate let shot: Shot
  let initialState: State

  init(provider: ServiceProviderType, shot: Shot) {
    self.provider = provider
    self.shot = shot
    self.initialState = State(imageURL: shot.imageURLs.teaser)
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .showShot:
      let reactor = ShotViewReactor(
        provider: self.provider,
        shotID: self.shot.id,
        shot: self.shot
      )
      state.navigation = .shot(reactor)
      return state
    }
  }
}
