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
import Immutable
import Kingfisher
import ManualLayout
import RxGesture
import RxOptional
import RxReusable
import RxViewController
import SnapKit
import SwiftyColor
import SwiftyImage
import Then
import TouchAreaInsets
import UITextView_Placeholder
import Umbrella
import URLNavigator
import WebLinking

let analytics = Umbrella.Analytics<AnalyticsEvent>()

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
    self.configureSDKs()
    self.configureAnalytics()
    self.configureAppearance()

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.makeKeyAndVisible()

    URLNavigationMap.initialize()

    let authService = AuthService()
    let userService = UserService()
    let shotService = ShotService()

    let presentMainScreen: () -> Void = { [weak self] in
      let shotListViewReactor = ShotListViewReactor(
        shotService: shotService,
        shotCellReactorFactory: ShotCellReactor.init
      )
      let shotTileCellDependency = ShotTileCell.Dependency(
        imageOptions: [],
        shotViewControllerFactory: { id, shot in
          ShotViewController(reactor: ShotViewReactor(shotID: id, shot: shot))
        }
      )
      let shotListViewController = ShotListViewController(
        reactor: shotListViewReactor,
        shotTileCellDependency: shotTileCellDependency
      )
      let mainTabBarController = MainTabBarController(
        reactor: MainTabBarViewReactor(),
        shotListViewController: shotListViewController,
        settingsViewController: SettingsViewController(reactor: SettingsViewReactor())
      )
      self?.window?.rootViewController = mainTabBarController
    }
    let presentLoginScreen: () -> Void = { [weak self] in
      let reactor = LoginViewReactor(authService: authService, userService: userService)
      self?.window?.rootViewController = LoginViewController(
        reactor: reactor,
        presentMainScreen: presentMainScreen
      )
    }

    let reactor = SplashViewReactor(userService: userService)
    let splashViewController = SplashViewController(
      reactor: reactor,
      presentLoginScreen: presentLoginScreen,
      presentMainScreen: presentMainScreen
    )
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
    FirebaseApp.configure()
  }


  // MARK: Analytics

  private func configureAnalytics() {
    analytics.register(provider: FirebaseProvider())
  }


  // MARK: Appearance

  private func configureAppearance() {
    let navigationBarBackgroundImage = UIImage.resizable().color(.db_charcoal).image
    UINavigationBar.appearance().setBackgroundImage(navigationBarBackgroundImage, for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().barStyle = .black
    UINavigationBar.appearance().tintColor = .db_slate
    UITabBar.appearance().tintColor = .db_charcoal
  }
}
