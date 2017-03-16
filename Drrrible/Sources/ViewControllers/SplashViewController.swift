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
    self.configure(input: reactor)
    self.configure(output: reactor)
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

  private func configure(input: SplashViewReactorInput) {
    self.rx.viewDidAppear
      .map { _ in Void() }
      .bindTo(input.viewDidAppear)
      .addDisposableTo(self.disposeBag)
  }

  private func configure(output: SplashViewReactorOutput) {
    output.presentLoginScreen
      .subscribe(onNext: { reactor in
        AppDelegate.shared.presentLoginScreen(reactor: reactor)
      })
      .addDisposableTo(self.disposeBag)

    output.presentMainScreen
      .subscribe(onNext: { reactor in
        AppDelegate.shared.presentMainScreen(reactor: reactor)
      })
      .addDisposableTo(self.disposeBag)
  }

}
