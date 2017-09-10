//
//  ShotTileCellTests.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 23/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Nimble
import Quick
@testable import Drrrible

final class ShotTileCellSpec: QuickSpec {
  override func spec() {
    var reactor: ShotCellReactor!
    var cell: ShotTileCell!

    beforeEach {
      reactor = ShotCellReactor(shot: ShotFixture.shot1)
      reactor.stub.isEnabled = true
      cell = ShotTileCell()
    }

    it("has subviews") {
      let cell = ShotTileCell()
      expect(cell.cardView.superview) === cell.contentView
      expect(cell.imageView.superview) === cell.cardView
      expect(cell.gifLabel.superview) === cell.imageView
    }

    describe("an image view") {
      it("sets an url") {
        let imageDownloader = StubImageDownloader()
        cell.dependency = .stub(downloader: imageDownloader)
        cell.reactor = reactor
        reactor.stub.state.value.imageURL = URL(string: "https://www.example.com")!
        expect(cell.imageView.kf.webURL) == URL(string: "https://www.example.com")
      }
    }

    describe("a gif label") {
      beforeEach {
        cell.dependency = .stub()
        cell.reactor = reactor
      }

      context("when an image is animated") {
        it("is not hidden") {
          reactor.stub.state.value.isAnimatedImage = true
          expect(cell.gifLabel.isHidden) == false
        }
      }

      context("when an image is not animated") {
        it("is hidden") {
          reactor.stub.state.value.isAnimatedImage = false
          expect(cell.gifLabel.isHidden) == true
        }
      }
    }

    describe("a card view") {
      context("when taps") {
        it("navigates to a shot view controller") {
          var isShotViewControllerFactoryExecuted = false
          cell.dependency = .stub(
            shotViewControllerFactory: { id, shot in
              isShotViewControllerFactoryExecuted = true
              let reactor = ShotViewReactor.stub(shotID: id)
              reactor.stub.isEnabled = true
              return ShotViewController(
                reactor: reactor,
                analytics: .stub(),
                shotSectionDelegateFactory: { .stub() }
              )
            }
          )
          cell.reactor = reactor
          let gestureRecognizer = cell.cardView.gestureRecognizers?.lazy.flatMap { $0 as? UITapGestureRecognizer }.first
          gestureRecognizer?.sendAction(withState: .ended)
          expect(isShotViewControllerFactoryExecuted) == true
        }
      }
    }
  }
}
