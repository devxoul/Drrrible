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
  Bundle.main.object(forInfoDictionaryKey: "")
  return isTesting ? "DrrribleTests.MockAppDelegate" : NSStringFromClass(AppDelegate.self)
}

UIApplicationMain(
  CommandLine.argc,
  UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(
    to: UnsafeMutablePointer<Int8>.self,
    capacity: Int(CommandLine.argc)
  ),
  NSStringFromClass(UIApplication.self),
  appDelegateClassName()
)
