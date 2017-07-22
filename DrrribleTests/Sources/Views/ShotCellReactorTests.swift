//
//  ShotCellReactorTests.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 23/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest
@testable import Drrrible

final class ShotCellReactorTests: TestCase {
  func testInitialState() {
    let reactor = ShotCellReactor(shot: ShotFixture.shot1)
    XCTAssertEqual(reactor.currentState.imageURL, ShotFixture.shot1.imageURLs.normal)
    XCTAssertEqual(reactor.currentState.isAnimatedImage, ShotFixture.shot1.isAnimatedImage)
  }
}
