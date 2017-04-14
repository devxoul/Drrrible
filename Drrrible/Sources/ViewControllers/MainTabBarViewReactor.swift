//
//  MainTabBarViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class MainTabBarViewReactor: Reactor {
  typealias Action = NoAction

  struct State {
    var shotListViewReactor: ShotListViewReactor
    var settingsViewReactor: SettingsViewReactor
  }

  let initialState: State

  init(provider: ServiceProviderType) {
    self.initialState = State(
      shotListViewReactor: ShotListViewReactor(provider: provider),
      settingsViewReactor: SettingsViewReactor(provider: provider)
    )
  }

}
