//
//  SplashViewController.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class SplashViewController: BaseViewController {

  // MARK: UI

  fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)


  // MARK: Initializing

  init(reactor: SplashViewReactorType) {
    super.init()
    self.configure(reactor: reactor)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


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

  private func configure(reactor: SplashViewReactorType) {
    self.rx.viewDidAppear
      .map { _ in Void() }
      .bindTo(reactor.checkIfAuthenticated)
      .addDisposableTo(self.disposeBag)

    reactor.presentLoginScreen
      .subscribe(onNext: { reactor in
        AppDelegate.shared.presentLoginScreen(reactor: reactor)
      })
      .addDisposableTo(self.disposeBag)

    reactor.presentMainScreen
      .subscribe(onNext: { reactor in
        AppDelegate.shared.presentMainScreen(reactor: reactor)
      })
      .addDisposableTo(self.disposeBag)
  }

}
