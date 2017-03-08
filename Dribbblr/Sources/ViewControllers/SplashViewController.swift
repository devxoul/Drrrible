//
//  SplashViewController.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class SplashViewController: BaseViewController {

  // MARK: UI

  fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)


  // MARK: Initializing

  init(viewModel: SplashViewModelType) {
    super.init()
    self.configure(input: viewModel)
    self.configure(output: viewModel)
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

  private func configure(input: SplashViewModelInput) {
    self.rx.viewDidAppear
      .map { _ in Void() }
      .bindTo(input.viewDidAppear)
      .addDisposableTo(self.disposeBag)
  }

  private func configure(output: SplashViewModelOutput) {
    output.presentLoginScreen
      .subscribe(onNext: { viewModel in
        AppDelegate.shared.presentLoginScreen(viewModel: viewModel)
      })
      .addDisposableTo(self.disposeBag)

    output.presentMainScreen
      .subscribe(onNext: { viewModel in
        AppDelegate.shared.presentMainScreen(viewModel: viewModel)
      })
      .addDisposableTo(self.disposeBag)
  }

}
