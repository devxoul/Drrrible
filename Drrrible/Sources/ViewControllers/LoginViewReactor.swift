//
//  LoginViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxSwiftUtilities

final class LoginViewReactor: Reactor {

  enum Action {
    case login
  }

  enum Mutation {
    case setLoading(Bool)
    case setNavigation(Navigation)
  }

  struct State {
    var isLoading: Bool = false
    var navigation: Navigation?
  }

  enum Navigation {
    case main(MainTabBarViewReactor)
  }

  let provider: ServiceProviderType
  let initialState: State = State()

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .login:
      let setLoading = Observable.just(Mutation.setLoading(true))
      let setNavigation = self.provider.authService.authorize()
        .flatMap { self.provider.userService.fetchMe() }
        .map { _ -> Mutation in
          let reactor = MainTabBarViewReactor(provider: self.provider)
          return Mutation.setNavigation(.main(reactor))
        }
      return setLoading.concat(setNavigation)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setLoading(isLoading):
      state.isLoading = isLoading
      return state

    case let .setNavigation(navigation):
      state.navigation = navigation
      return state
    }
  }

}
