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
    static let logoViewTop = 70.f
    static let logoViewSize = 225.f

    static let titleLabelTop = 10.f

    static let loginButtonLeftRight = 30.f
    static let loginButtonBottom = 40.f
    static let loginButtonHeight = 40.f
  }

  fileprivate struct Font {
    static let titleLabel = UIFont.boldSystemFont(ofSize: 60)
    static let loginButtonTitle = UIFont.boldSystemFont(ofSize: 15)
  }


  // MARK: Properties

  fileprivate let analytics: DrrribleAnalytics
  fileprivate let presentMainScreen: () -> Void


  // MARK: UI

  let logoView = UIImageView(image: #imageLiteral(resourceName: "Icon512"))
  let titleLabel = UILabel().then {
    $0.text = "Drrrible"
    $0.font = Font.titleLabel
  }
  let loginButton = UIButton().then {
    $0.titleLabel?.font = Font.loginButtonTitle
    $0.setTitle("login_with_dribbble".localized, for: .normal)
    $0.setBackgroundImage(
      UIImage.resizable()
        .color(0xFF2719.color)
        .corner(radius: 3)
        .image,
      for: .normal
    )
    $0.setBackgroundImage(
      UIImage.resizable()
        .color(0xC32116.color)
        .corner(radius: 3)
        .image,
      for: .highlighted
    )
  }
  let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)


  // MARK: Initializing

  init(
    reactor: LoginViewReactor,
    analytics: DrrribleAnalytics,
    presentMainScreen: @escaping () -> Void
  ) {
    defer { self.reactor = reactor }
    self.analytics = analytics
    self.presentMainScreen = presentMainScreen
    super.init()
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.addSubview(self.logoView)
    self.view.addSubview(self.titleLabel)
    self.view.addSubview(self.loginButton)
    self.view.addSubview(self.activityIndicatorView)
  }

  override func setupConstraints() {
    self.logoView.snp.makeConstraints { make in
      make.top.equalTo(Metric.logoViewTop)
      make.centerX.equalToSuperview()
      make.size.equalTo(Metric.logoViewSize)
    }
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.logoView.snp.bottom).offset(Metric.titleLabelTop)
      make.centerX.equalToSuperview()
    }
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
      .distinctUntilChanged()
      .bind(to: self.loginButton.rx.isHidden)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.isLoading }
      .distinctUntilChanged()
      .bind(to: self.activityIndicatorView.rx.isAnimating)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.isLoggedIn }
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(onNext: { [weak self] _ in
        self?.presentMainScreen()
      })
      .disposed(by: self.disposeBag)

    // Analytics
    self.loginButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.analytics.log(.tryLogin)
      })
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.isLoggedIn }
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(onNext: { [weak self] _ in
        self?.analytics.log(.login)
      })
      .disposed(by: self.disposeBag)
  }
}
