//
//  TestCase.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest

import RxSwift

@testable import Drrrible

class TestCase: XCTestCase {
  override func setUp() {
    UIApplication.shared.delegate = StubAppDelegate()
    clearStubs()
  }

  override func tearDown() {
    clearStubs()
    super.tearDown()
  }
}
