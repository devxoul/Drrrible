//
//  ShotViewImageCellSpec.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Quick
import Nimble
@testable import Drrrible

final class ShotViewImageCellSpec: QuickSpec {
  override func spec() {
    var reactor: ShotViewImageCellReactor!
    var cell: ShotViewImageCell!

    beforeEach {
      reactor = ShotViewImageCellReactor(shot: ShotFixture.shot1)
      reactor.stub.isEnabled = true
      cell = ShotViewImageCell()
    }

    it("has subviews") {
      expect(cell.imageView.superview) == cell.contentView
    }

    describe("an image view") {
      it("sets an url") {
        cell.dependency = .stub()
        cell.reactor = reactor
        reactor.stub.state.value.imageURL = URL(string: "https://www.example.com")!
        expect(cell.imageView.kf.webURL) == URL(string: "https://www.example.com")!
      }
    }
  }
}
