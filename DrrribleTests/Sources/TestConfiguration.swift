//
//  TestConfiguration.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Quick
import Stubber
@testable import Drrrible

class TestConfiguration: QuickConfiguration {
  override class func configure(_ configuration: Configuration) {
    configuration.beforeEach {
      Stubber.clear()
      UIApplication.shared.delegate = StubAppDelegate()
    }

    configuration.afterEach {
      Stubber.clear()
    }
  }
}
