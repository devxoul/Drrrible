//
//  TestCase.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest

class TestCase: XCTestCase {
  override func setUp() {
//    super.setUp()
    UIApplication.shared.delegate = MockAppDelegate()
  }
}
