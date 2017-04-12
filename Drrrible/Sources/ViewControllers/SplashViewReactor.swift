//
//  SplashViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Reactor
import RxCocoa
import RxSwift

enum SplashViewAction {
  case checkIfAuthenticated
}

enum SplashViewMutation {
  case setNavigation(SplashViewState.Navigation)
}

struct SplashViewState {
  enum Navigation {
    case login(LoginViewReactor)
    case main(MainTabBarViewReactor)
  }

  var navigation: Navigation?
}

final class SplashViewReactor: Reactor<SplashViewAction, SplashViewMutation, SplashViewState> {

  fileprivate let provider: ServiceProviderType


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    self.provider = provider
    let initialState = State()
    super.init(initialState: initialState)
  }

  override func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .checkIfAuthenticated:
      return self.provider.userService.fetchMe()
        .map { State.Navigation.login(LoginViewReactor(provider: self.provider)) }
        .catchErrorJustReturn(State.Navigation.main(MainTabBarViewReactor(provider: self.provider)))
        .map(Mutation.setNavigation)
    }
  }

  override func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setNavigation(navigation):
      state.navigation = navigation
      return state
    }
  }

}
