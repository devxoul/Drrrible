//
//  MainTabBarViewModel.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol MainTabBarViewModelType {
  // Output
  var shotListViewModel: Driver<ShotListViewModelType> { get }
  var settingsViewModel: Driver<SettingsViewModelType> { get }
}

final class MainTabBarViewModel: MainTabBarViewModelType {

  // MARK: Output

  let shotListViewModel: Driver<ShotListViewModelType>
  let settingsViewModel: Driver<SettingsViewModelType>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    self.shotListViewModel = .just(ShotListViewModel(provider: provider))
    self.settingsViewModel = .just(SettingsViewModel(provider: provider))
  }

}
