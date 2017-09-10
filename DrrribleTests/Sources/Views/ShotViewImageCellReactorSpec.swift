//
//  ShotViewImageCellReactorSpec.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Quick
import Nimble
@testable import Drrrible

final class ShotViewImageCellReactorSpec: QuickSpec {
  override func spec() {
    describe("state.imageURL") {
      it("is same with initial parameter value") {
        let reactor = ShotViewImageCellReactor(shot: ShotFixture.shot1)
        expect(reactor.currentState.imageURL) == ShotFixture.shot1.imageURLs.normal
      }
    }
  }
}
