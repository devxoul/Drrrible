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

  static func initialize(provider: ServiceProviderType) {
    Navigator.map("drrrible://oauth/callback") { url, values in
      guard let code = url.queryParameters["code"] else { return false }
      provider.authService.callback(code: code)
      return true
    }
  }

}
