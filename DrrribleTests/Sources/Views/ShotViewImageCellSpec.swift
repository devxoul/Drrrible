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
      reactor.isStubEnabled = true
      cell = ShotViewImageCell()
    }

    it("has subviews") {
      expect(cell.imageView.superview) == cell.contentView
    }
  }
}
