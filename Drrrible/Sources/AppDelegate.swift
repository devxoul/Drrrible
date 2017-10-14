//
//  AppDelegate.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Properties

  var dependency: AppDependency!


  // MARK: UI

  var window: UIWindow?


  // MARK: UIApplicationDelegate

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    self.dependency = self.dependency ?? CompositionRoot.resolve()
    self.dependency.configureSDKs()
    self.dependency.configureAppearance()
    self.window = self.dependency.window
    return true
  }

  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplicationOpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    return self.dependency.openURL(url, options)
  }
}
