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

  init(reactor: MainTabBarViewReactorType) {
    super.init(nibName: nil, bundle: nil)
    self.configure(reactor: reactor)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  private func configure(reactor: MainTabBarViewReactorType) {
    // Output

    let shotListNavigationController: Driver<UINavigationController> = reactor.shotListViewReactor
      .map { ShotListViewController(reactor: $0) }
      .map { UINavigationController(rootViewController: $0) }

    let settingsNavigationController: Driver<UINavigationController> = reactor.settingsViewReactor
      .map { SettingsViewController(reactor: $0) }
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
