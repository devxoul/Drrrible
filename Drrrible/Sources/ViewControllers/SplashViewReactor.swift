//
//  SplashViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class SplashViewReactor: Reactor {

  enum Action {
    case checkIfAuthenticated
  }

  enum Mutation {
    case setAuthenticated(Bool)
  }

  struct State {
    var isAuthenticated: Bool?
  }

  let provider: ServiceProviderType
  let initialState: State


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    self.provider = provider
    self.initialState = State()
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .checkIfAuthenticated:
      return self.provider.userService.fetchMe()
        .map { true }
        .catchErrorJustReturn(false)
        .map(Mutation.setAuthenticated)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setAuthenticated(isAuthenticated):
      state.isAuthenticated = isAuthenticated
      return state
    }
  }

}
