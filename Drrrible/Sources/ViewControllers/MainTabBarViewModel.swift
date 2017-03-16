//
//  MainTabBarViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol MainTabBarViewReactorType {
  // Output
  var shotListViewReactor: Driver<ShotListViewReactorType> { get }
  var settingsViewReactor: Driver<SettingsViewReactorType> { get }
}

final class MainTabBarViewReactor: MainTabBarViewReactorType {

  // MARK: Output

  let shotListViewReactor: Driver<ShotListViewReactorType>
  let settingsViewReactor: Driver<SettingsViewReactorType>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    self.shotListViewReactor = .just(ShotListViewReactor(provider: provider))
    self.settingsViewReactor = .just(SettingsViewReactor(provider: provider))
  }

}
