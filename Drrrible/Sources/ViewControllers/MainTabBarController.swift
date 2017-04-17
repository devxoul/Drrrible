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

final class MainTabBarController: UITabBarController, View {

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

    let settingsNavigationController = reactor.state.map { $0.settingsViewReactor }
      .map { reactor -> UINavigationController in
        let viewController = SettingsViewController()
        viewController.reactor = reactor
        return UINavigationController(rootViewController: viewController)
      }

    let navigationControllers: [Observable<UINavigationController>] = [
      shotListNavigationController,
      settingsNavigationController,
    ]
    Observable.combineLatest(navigationControllers) { $0 }
      .subscribe(onNext: { [weak self] navigationControllers in
        self?.viewControllers = navigationControllers
      })
      .disposed(by: self.disposeBag)
  }

}
