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

struct ShotCellComponents: ReactorComponents {
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
}

final class ShotCellReactor: Reactor<ShotCellComponents> {
  fileprivate let provider: ServiceProviderType
  fileprivate let shot: Shot

  init(provider: ServiceProviderType, shot: Shot) {
    self.provider = provider
    self.shot = shot

    let initialState = State(imageURL: shot.imageURLs.teaser)
    super.init(initialState: initialState)
  }

  override func reduce(state: State, mutation: Mutation) -> State {
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
