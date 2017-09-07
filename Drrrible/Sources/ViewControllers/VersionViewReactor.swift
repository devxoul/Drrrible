//
//  VersionViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

final class VersionViewReactor: Reactor {
  enum Action {
    case checkForUpdates
  }

  enum Mutation {
    case setLoading(Bool)
    case setLatestVersion(String?)
  }

  struct State {
    var isLoading: Bool = false
    var currentVersion: String = Bundle.main.version ?? "0.0.0"
    var latestVersion: String?
  }

  fileprivate let appStoreService: AppStoreServiceType
  let initialState = State()

  init(appStoreService: AppStoreServiceType) {
    self.appStoreService = appStoreService
    _ = self.state
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .checkForUpdates:
      let startLoading: Observable<Mutation> = .just(.setLoading(true))
      let clearLatestVersion: Observable<Mutation> = .just(.setLatestVersion(nil))
      let setLatestVersion: Observable<Mutation> = self.appStoreService.latestVersion()
        .asObservable()
        .map { $0 ?? "⚠️" }
        .map(Mutation.setLatestVersion)
      let stopLoading: Observable<Mutation> = .just(.setLoading(false))
      return Observable.concat([startLoading, clearLatestVersion, setLatestVersion, stopLoading])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setLoading(isLoading):
      state.isLoading = isLoading
      return state

    case let .setLatestVersion(latestVersion):
      state.latestVersion = latestVersion
      return state
    }
  }
}
