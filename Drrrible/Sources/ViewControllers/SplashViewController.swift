//
//  SplashViewController.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit

final class SplashViewController: BaseViewController, View {

  typealias Reactor = SplashViewReactor


  // MARK: UI

  fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.activityIndicatorView.startAnimating()
    self.view.addSubview(self.activityIndicatorView)
  }

  override func setupConstraints() {
    self.activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }


  // MARK: Configuring

  func configure(reactor: Reactor) {
    // Action
    self.rx.viewDidAppear
      .map { _ in Reactor.Action.checkIfAuthenticated }
      .bindTo(reactor.action)
      .addDisposableTo(self.disposeBag)

    // State
    reactor.state.map { $0.navigation }.debug()
      .filterNil()
      .subscribe(onNext: { navigation in
        switch navigation {
        case let .login(reactor):
          AppDelegate.shared.presentLoginScreen(reactor: reactor)

        case let .main(reactor):
          AppDelegate.shared.presentMainScreen(reactor: reactor)
        }
      })
      .addDisposableTo(self.disposeBag)
  }

}
