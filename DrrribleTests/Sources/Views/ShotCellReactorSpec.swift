//
//  ShotCellReactorSpec.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 23/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Nimble
import Quick
@testable import Drrrible

final class ShotCellReactorSpec: QuickSpec {
  override func spec() {
    var reactor: ShotCellReactor!

    beforeEach {
      reactor = ShotCellReactor(shot: ShotFixture.shot1)
    }

    describe("state.imageURL") {
      it("is same with the initialize parameter value") {
        expect(reactor.currentState.imageURL) == ShotFixture.shot1.imageURLs.normal
      }
    }

    describe("state.isAnimatedImage") {
      it("is same with the initialize parameter value") {
        expect(reactor.currentState.isAnimatedImage) == ShotFixture.shot1.isAnimatedImage
      }
    }
  }
}
