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

final class LoginViewReactor: Reactor {
  enum Action {
    case login
  }

  enum Mutation {
    case setLoading(Bool)
    case setLoggedIn(Bool)
  }

  struct State {
    var isLoading: Bool = false
    var isLoggedIn: Bool = false
  }

  let initialState: State = State()

  fileprivate let authService: AuthServiceType
  fileprivate let userService: UserServiceType

  init(authService: AuthServiceType, userService: UserServiceType) {
    self.authService = authService
    self.userService = userService
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .login:
      let setLoading: Observable<Mutation> = .just(Mutation.setLoading(true))
      let setLoggedIn: Observable<Mutation> = self.authService.authorize()
        .asObservable()
        .flatMap { self.userService.fetchMe() }
        .map { true }
        .catchErrorJustReturn(false)
        .map(Mutation.setLoggedIn)
      return setLoading.concat(setLoggedIn)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setLoading(isLoading):
      state.isLoading = isLoading
      return state

    case let .setLoggedIn(isLoggedIn):
      state.isLoggedIn = isLoggedIn
      return state
    }
  }
}
