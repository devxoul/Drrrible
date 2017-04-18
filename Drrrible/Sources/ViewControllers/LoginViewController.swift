//
//  LoginViewController.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import SafariServices
import UIKit

import ReactorKit

final class LoginViewController: BaseViewController, View {

  // MARK: Constants

  fileprivate struct Metric {
    static let loginButtonLeftRight = 30.f
    static let loginButtonBottom = 30.f
    static let loginButtonHeight = 40.f
  }

  fileprivate struct Font {
    static let loginButtonTitle = UIFont.boldSystemFont(ofSize: 15)
  }


  // MARK: UI

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  fileprivate let loginButton = UIButton().then {
    $0.titleLabel?.font = Font.loginButtonTitle
    $0.setTitle("Login with Dribbble", for: .normal)
    $0.setBackgroundImage(
      UIImage.resizable()
        .color(.db_pink)
        .corner(radius: 3)
        .image,
      for: .normal
    )
    $0.setBackgroundImage(
      UIImage.resizable()
        .color(.db_darkPink)
        .corner(radius: 3)
        .image,
      for: .highlighted
    )
  }
  fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)


  // MARK: Initializing

  init(reactor: LoginViewReactor) {
    defer { self.reactor = reactor }
    super.init()
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .db_charcoal
    self.view.addSubview(self.loginButton)
    self.view.addSubview(self.activityIndicatorView)
  }

  override func setupConstraints() {
    self.loginButton.snp.makeConstraints { make in
      make.left.equalTo(Metric.loginButtonLeftRight)
      make.right.equalTo(-Metric.loginButtonLeftRight)
      make.bottom.equalTo(-Metric.loginButtonBottom)
      make.height.equalTo(Metric.loginButtonHeight)
    }
    self.activityIndicatorView.snp.makeConstraints { make in
      make.center.equalTo(self.loginButton)
    }
  }


  // MARK: Configuring

  func bind(reactor: LoginViewReactor) {
    // Input
    self.loginButton.rx.tap
      .map { Reactor.Action.login }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // Output
    reactor.state.map { $0.isLoading }
      .bind(to: self.loginButton.rx.isHidden)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.isLoading }
      .bind(to: self.activityIndicatorView.rx.isAnimating)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.isLoggedIn }
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(onNext: { _ in
        AppDelegate.shared.presentMainScreen()
      })
      .disposed(by: self.disposeBag)
  }

}
