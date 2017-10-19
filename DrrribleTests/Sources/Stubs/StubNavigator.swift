//
//  StubNavigator.swift
//  DrrribleTests
//
//  Created by Suyeol Jeon on 15/10/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Stubber
import URLNavigator

final class StubNavigator: NavigatorType {
  let matcher = URLMatcher()
  weak var delegate: NavigatorDelegate?

  func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory) {
    // do nothing
  }

  func handle(_ pattern: URLPattern, _ factory: @escaping URLOpenHandlerFactory) {
    // do nothing
  }

  func viewController(for url: URLConvertible, context: Any?) -> UIViewController? {
    return Stubber.invoke(viewController, args: (url, context), default: nil)
  }

  func handler(for url: URLConvertible, context: Any?) -> URLOpenHandler? {
    return Stubber.invoke(handler, args: (url, context), default: nil)
  }
}
