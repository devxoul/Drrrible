//
//  CompositionRoot.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 16/08/2017.
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
import RxCodable
import RxGesture
import RxOptional
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

struct AppDependency {
  typealias OpenURLHandler = (_ url: URL, _ options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool

  let window: UIWindow
  let navigator: Navigator
  let configureSDKs: () -> Void
  let configureAppearance: () -> Void
  let openURL: OpenURLHandler
}

final class CompositionRoot {
  /// Builds a dependency graph and returns an entry view controller.
  static func resolve() -> AppDependency {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.makeKeyAndVisible()

    let navigator = Navigator()

    let authService = AuthService(navigator: navigator)
    let networking = DrrribleNetworking(plugins: [AuthPlugin(authService: authService)])
    let appStoreService = AppStoreService()
    let userService = UserService(networking: networking)
    let shotService = ShotService(networking: networking)

    let analytics = DrrribleAnalytics()
    analytics.register(provider: FirebaseProvider())

    URLNavigationMap.initialize(navigator: navigator, authService: authService)

    let productionImageOptions: ImageOptions = []

    var presentMainScreen: (() -> Void)!
    var presentLoginScreen: (() -> Void)!
    presentMainScreen = {
      let shotListViewReactor = ShotListViewReactor(
        shotService: shotService,
        shotCellReactorFactory: ShotCellReactor.init
      )
      let shotSectionReactorFactory: (Int, Shot?) -> ShotSectionReactor = { shotID, shot in
        ShotSectionReactor(
          shotID: shotID,
          shot: shot,
          reactionCellReactorFactory: { shot in
            ShotViewReactionCellReactor(
              shot: shot,
              likeButtonViewReactorFactory: { shot in
                ShotViewReactionLikeButtonViewReactor(
                  shot: shot,
                  shotService: shotService,
                  analytics: analytics
                )
              },
              commentButtonViewReactorFactory: { shot in
                ShotViewReactionCommentButtonViewReactor(shot: shot)
              }
            )
          }
        )
      }
      let shotTileCellDependency = ShotTileCell.Dependency(
        imageOptions: productionImageOptions,
        navigator: navigator,
        shotViewControllerFactory: { id, shot in
          let reactor = ShotViewReactor(
            shotID: id,
            shot: shot,
            shotService: shotService,
            shotSectionReactorFactory: shotSectionReactorFactory
          )
          return ShotViewController(
            reactor: reactor,
            analytics: analytics,
            shotSectionDelegateFactory: {
              ShotSectionDelegate(
                imageCellDependency: .init(imageOptions: productionImageOptions),
                titleCellDependency: .init(imageOptions: productionImageOptions)
              )
            }
          )
        }
      )
      let shotListViewController = ShotListViewController(
        reactor: shotListViewReactor,
        analytics: analytics,
        shotTileCellDependency: shotTileCellDependency
      )
      let mainTabBarController = MainTabBarController(
        reactor: MainTabBarViewReactor(),
        shotListViewController: shotListViewController,
        settingsViewController: SettingsViewController(
          reactor: SettingsViewReactor(userService: userService),
          analytics: analytics,
          versionViewControllerFactory: {
            let reactor = VersionViewReactor(appStoreService: appStoreService)
            return VersionViewController(reactor: reactor)
          },
          presentLoginScreen: presentLoginScreen
        )
      )
      window.rootViewController = mainTabBarController
    }
    presentLoginScreen = {
      let reactor = LoginViewReactor(authService: authService, userService: userService)
      window.rootViewController = LoginViewController(
        reactor: reactor,
        analytics: analytics,
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

    return AppDependency(
      window: window,
      navigator: navigator,
      configureSDKs: self.configureSDKs,
      configureAppearance: self.configureAppearance,
      openURL: self.openURLFactory(navigator: navigator)
    )
  }

  static func configureSDKs() {
    Fabric.with([Crashlytics.self])
    FirebaseApp.configure()
  }

  static func configureAppearance() {
    let navigationBarBackgroundImage = UIImage.resizable().color(.db_charcoal).image
    UINavigationBar.appearance().setBackgroundImage(navigationBarBackgroundImage, for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().barStyle = .black
    UINavigationBar.appearance().tintColor = .db_slate
    UITabBar.appearance().tintColor = .db_charcoal
  }

  static func openURLFactory(navigator: NavigatorType) -> AppDependency.OpenURLHandler {
    return { url, options -> Bool in
      if navigator.open(url) {
        return true
      }
      if navigator.present(url, wrap: UINavigationController.self) != nil {
        return true
      }
      return false
    }
  }
}
