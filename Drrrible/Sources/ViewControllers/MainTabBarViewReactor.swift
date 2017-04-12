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

struct MainTabBarViewComponents: ReactorComponents {
  struct State {
    var shotListViewReactor: ShotListViewReactor
    var settingsViewReactor: SettingsViewReactor
  }
}

final class MainTabBarViewReactor: Reactor<MainTabBarViewComponents> {

  init(provider: ServiceProviderType) {
    let initialState = State(
      shotListViewReactor: ShotListViewReactor(provider: provider),
      settingsViewReactor: SettingsViewReactor(provider: provider)
    )
    super.init(initialState: initialState)
  }

}
