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
    case setNavigation(Navigation)
  }

  struct State {
    var navigation: Navigation?
  }

  enum Navigation {
    case login(LoginViewReactor)
    case main(MainTabBarViewReactor)
  }

  fileprivate let provider: ServiceProviderType
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
        .map { _ -> Mutation in
          let reactor = LoginViewReactor(provider: self.provider)
          return .setNavigation(.login(reactor))
        }
        .catchErrorJustReturn({ _ -> Mutation in
          let reactor = MainTabBarViewReactor(provider: self.provider)
          return .setNavigation(.main(reactor))
        }())
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setNavigation(navigation):
      state.navigation = navigation
      return state
    }
  }

}
