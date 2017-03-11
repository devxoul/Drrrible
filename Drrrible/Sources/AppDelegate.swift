//
//  AppDelegate.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import CGFloatLiteral
import Kingfisher
import ManualLayout
import RxOptional
import RxReusable
import SnapKit
import SwiftyColor
import SwiftyImage
import Then
import UITextView_Placeholder
import URLNavigator
import WebLinking
import Yet

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Properties

  class var shared: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }


  // MARK: UI

  var window: UIWindow?


  // MARK: UIApplicationDelegate

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    self.configureAppearance()

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.makeKeyAndVisible()

    let serviceProvider: ServiceProviderType = ServiceProvider()
    URLNavigationMap.initialize(provider: serviceProvider)

    let splashViewModel = SplashViewModel(provider: serviceProvider)
    let splashViewController = SplashViewController(viewModel: splashViewModel)
    window.rootViewController = splashViewController

    self.window = window
    return true
  }

  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplicationOpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    if Navigator.open(url) {
      return true
    }
    if Navigator.present(url, wrap: true) != nil {
      return true
    }
    return false
  }


  // MARK: Appearance

  private func configureAppearance() {
    let navigationBarBackgroundImage = UIImage.resizable().color(.db_charcoal).image
    UINavigationBar.appearance().setBackgroundImage(navigationBarBackgroundImage, for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().barStyle = .black
    UINavigationBar.appearance().tintColor = .db_slate
  }


  // MARK: Presenting

  func presentLoginScreen(viewModel: LoginViewModelType) {
    let viewController = LoginViewController(viewModel: viewModel)
    self.window?.rootViewController = viewController
  }

  func presentMainScreen(viewModel: MainTabBarViewModelType) {
    let mainTabBarController = MainTabBarController(viewModel: viewModel)
    self.window?.rootViewController = mainTabBarController
  }

}
