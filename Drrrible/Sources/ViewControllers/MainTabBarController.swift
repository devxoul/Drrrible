//
//  MainTabBarController.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class MainTabBarController: UITabBarController, ViewType {

  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: Configuring

  func configure(reactor: MainTabBarViewReactor) {
    let shotListNavigationController = reactor.state.map { $0.shotListViewReactor }
      .map { reactor -> UINavigationController in
        let viewController = ShotListViewController()
        viewController.reactor = reactor
        return UINavigationController(rootViewController: viewController)
      }

    let settingsNavigationController: Observable<UINavigationController> = reactor.state
      .map { $0.settingsViewReactor }
      .distinctUntilChanged { $0 === $1 }
      .map { SettingsViewController(reactor: $0) }
      .map { UINavigationController(rootViewController: $0) }

    let navigationControllers: [Observable<UINavigationController>] = [
      shotListNavigationController,
      settingsNavigationController,
    ]
    Observable.combineLatest(navigationControllers) { $0 }
      .subscribe(onNext: { [weak self] navigationControllers in
        self?.viewControllers = navigationControllers
      })
      .addDisposableTo(self.disposeBag)
  }

}
