//
//  main.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

private func appDelegateClassName() -> String {
  let isTesting = NSClassFromString("XCTestCase") != nil
  return isTesting ? "DrrribleTests.StubAppDelegate" : NSStringFromClass(AppDelegate.self)
}

_ = UIApplicationMain(
  CommandLine.argc,
  CommandLine.unsafeArgv,
  NSStringFromClass(UIApplication.self),
  appDelegateClassName()
)
