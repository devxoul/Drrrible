//
//  ShotTileCellTests.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 23/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest
@testable import Drrrible

final class ShotTileCellTests: TestCase {
  func testSubviews() {
    let cell = ShotTileCell()
    XCTAssertEqual(cell.cardView.superview, cell.contentView)
    XCTAssertEqual(cell.imageView.superview, cell.cardView)
    XCTAssertEqual(cell.gifLabel.superview, cell.imageView)
  }

  func testState_imageURL() {
    let imageDownloader = StubImageDownloader()
    let reactor = ShotCellReactor(shot: ShotFixture.shot1)
    reactor.stub.isEnabled = true
    let cell = ShotTileCell()
    cell.dependency = .stub(downloader: imageDownloader)
    cell.reactor = reactor
    reactor.stub.state.value.imageURL = URL(string: "https://www.example.com")!
    XCTAssertEqual(imageDownloader.url?.absoluteString, "https://www.example.com")
  }

  func testState_isAnimatedImage() {
    let reactor = ShotCellReactor(shot: ShotFixture.shot1)
    reactor.stub.isEnabled = true
    let cell = ShotTileCell()
    cell.dependency = .stub()
    cell.reactor = reactor
    XCTAssertEqual(cell.gifLabel.isHidden, true)
    reactor.stub.state.value.isAnimatedImage = true
    XCTAssertEqual(cell.gifLabel.isHidden, false)
  }
}
