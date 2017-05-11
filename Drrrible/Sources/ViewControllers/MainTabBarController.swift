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


  // MARK: Initializing

  init(reactor: MainTabBarViewReactor) {
    defer { self.reactor = reactor }
    super.init(nibName: nil, bundle: nil)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func bind(reactor: MainTabBarViewReactor) {
    let shotListNavigationController = reactor.state.map { $0.shotListViewReactor }
      .map { reactor -> UINavigationController in
        let viewController = ShotListViewController(reactor: reactor)
        return UINavigationController(rootViewController: viewController)
      }

    let settingsNavigationController = reactor.state.map { $0.settingsViewReactor }
      .map { reactor -> UINavigationController in
        let viewController = SettingsViewController(reactor: reactor)
        return UINavigationController(rootViewController: viewController)
      }

    let navigationControllers: [Observable<UINavigationController>] = [
      shotListNavigationController,
      settingsNavigationController,
    ]
    Observable.combineLatest(navigationControllers) { $0 }
      .subscribe(onNext: { [weak self] navigationControllers in
        for navigationController in navigationControllers {
          navigationController.tabBarItem.title = nil
          navigationController.tabBarItem.imageInsets.top = 5
          navigationController.tabBarItem.imageInsets.bottom = -5
        }
        self?.viewControllers = navigationControllers
      })
      .disposed(by: self.disposeBag)

    self.rx.didSelect
      .scan((nil, nil)) { state, viewController in
        return (state.1, viewController)
      }
      // if select the view controller first time or select the same view controller again
      .filter { state in state.0 == nil || state.0 === state.1 }
      .map { state in state.1 }
      .filterNil()
      .subscribe(onNext: { [weak self] viewController in
        self?.scrollToTop(viewController) // scroll to top
      })
      .disposed(by: self.disposeBag)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.tabBar.height = 44
    self.tabBar.bottom = self.view.height
  }

  func scrollToTop(_ viewController: UIViewController) {
    if let navigationController = viewController as? UINavigationController {
      let topViewController = navigationController.topViewController
      let firstViewController = navigationController.viewControllers.first
      if let viewController = topViewController, topViewController === firstViewController {
        self.scrollToTop(viewController)
      }
      return
    }
    guard let scrollView = viewController.view.subviews.first as? UIScrollView else { return }
    scrollView.setContentOffset(.zero, animated: true)
  }

}
