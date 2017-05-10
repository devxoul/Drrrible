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
  static func initialize() {
    Navigator.map("drrrible://shot/<int:id>", ShotViewController.self)
    Navigator.map("drrrible://oauth/callback") { url, values in
      guard let code = url.queryParameters["code"] else { return false }
      DI.resolve(AuthServiceType.self)?.callback(code: code)
      return true
    }
  }
}
