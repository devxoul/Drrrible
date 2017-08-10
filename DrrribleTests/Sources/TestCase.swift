//
//  TestCase.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest

import RxSwift
import Stubber

@testable import Drrrible

class TestCase: XCTestCase {
  override func setUp() {
    super.setUp()
    Stubber.clear()
    UIApplication.shared.delegate = StubAppDelegate()
  }

  override func tearDown() {
    Stubber.clear()
    super.tearDown()
  }
}
