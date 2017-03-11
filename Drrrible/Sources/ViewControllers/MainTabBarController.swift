//
//  MainTabBarController.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class MainTabBarController: UITabBarController {

  // MARK: Properties

  fileprivate let disposeBag = DisposeBag()


  // MARK: Initializing

  init(viewModel: MainTabBarViewModelType) {
    super.init(nibName: nil, bundle: nil)
    self.configure(viewModel: viewModel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  private func configure(viewModel: MainTabBarViewModelType) {
    // Output

    let shotListNavigationController: Driver<UINavigationController> = viewModel.shotListViewModel
      .map { ShotListViewController(viewModel: $0) }
      .map { UINavigationController(rootViewController: $0) }

    let settingsNavigationController: Driver<UINavigationController> = viewModel.settingsViewModel
      .map { SettingsViewController(viewModel: $0) }
      .map { UINavigationController(rootViewController: $0) }

    let navigationControllers: [Driver<UINavigationController>] = [
      shotListNavigationController,
      settingsNavigationController,
    ]
    Driver.combineLatest(navigationControllers) { $0 }
      .drive(onNext: { [weak self] navigationControllers in
        self?.viewControllers = navigationControllers
      })
      .addDisposableTo(self.disposeBag)
  }

}
