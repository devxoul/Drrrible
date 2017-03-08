//
//  LoginViewController.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import SafariServices
import UIKit

final class LoginViewController: BaseViewController {

  // MARK: Constants

  fileprivate struct Metric {
    static let loginButtonLeftRight = 15.f
    static let loginButtonBottom = 30.f
  }


  // MARK: UI

  fileprivate let loginButton = UIButton(type: .system).then {
    $0.setTitle("Login", for: .normal)
  }


  // MARK: Initializing

  init(viewModel: LoginViewModelType) {
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
    self.view.addSubview(self.loginButton)
  }

  override func setupConstraints() {
    self.loginButton.snp.makeConstraints { make in
      make.left.equalTo(Metric.loginButtonLeftRight)
      make.right.equalTo(-Metric.loginButtonLeftRight)
      make.bottom.equalTo(-Metric.loginButtonBottom)
    }
  }


  // MARK: Configuring

  private func configure(input: LoginViewModelInput) {
    self.loginButton.rx.tap
      .bindTo(input.loginButtonDidTap)
      .addDisposableTo(self.disposeBag)
  }

  private func configure(output: LoginViewModelOutput) {
    output.loginButtonEnabled
      .drive(self.loginButton.rx.isEnabled)
      .addDisposableTo(self.disposeBag)

    output.presentMainScreen
      .subscribe(onNext: AppDelegate.shared.presentMainScreen)
      .addDisposableTo(self.disposeBag)
  }

}
