//
//  AppDelegate.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import CGFloatLiteral
import Crashlytics
import Fabric
import Firebase
import Kingfisher
import ManualLayout
import RxGesture
import RxOptional
import RxReusable
import SnapKit
import SwiftyColor
import SwiftyImage
import Then
import TouchAreaInsets
import UITextView_Placeholder
import URLNavigator
import WebLinking
import Yet

final class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Properties

  class var shared: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  fileprivate let serviceProvider: ServiceProviderType = ServiceProvider()


  // MARK: UI

  var window: UIWindow?


  // MARK: UIApplicationDelegate

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    self.configureSDKs()
    self.configureAppearance()

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.makeKeyAndVisible()

    URLNavigationMap.initialize(provider: self.serviceProvider)

    let reactor = SplashViewReactor(provider: self.serviceProvider)
    let splashViewController = SplashViewController(reactor: reactor)
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


  // MARK: SDKs

  private func configureSDKs() {
    self.configureFabric()
    self.configureFirebase()
  }

  private func configureFabric() {
    Fabric.with([Crashlytics.self])
  }

  private func configureFirebase() {
    FIRApp.configure()
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

  func presentLoginScreen() {
    let reactor = LoginViewReactor(provider: self.serviceProvider)
    let viewController = LoginViewController(reactor: reactor)
    self.window?.rootViewController = viewController
  }

  func presentMainScreen() {
    let reactor = MainTabBarViewReactor(provider: self.serviceProvider)
    let mainTabBarController = MainTabBarController(reactor: reactor)
    self.window?.rootViewController = mainTabBarController
  }

}
