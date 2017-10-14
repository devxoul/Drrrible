//
//  URLNavigationMap.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import URLNavigator

final class URLNavigationMap {
  static func initialize(
    navigator: NavigatorType,
    authService: AuthServiceType
  ) {
    navigator.handle("drrrible://oauth/callback") { url, values, context in
      guard let code = url.queryParameters["code"] else { return false }
      authService.callback(code: code)
      return true
    }
  }
}
