//
//  ShotViewControllerSpec.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 15/08/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Nimble
import Quick
@testable import Drrrible

final class ShotViewControllerSpec: QuickSpec {
  override func spec() {
    var reactor: ShotViewReactor!
    var analytics: StubAnalytics!
    var viewController: ShotViewController!

    beforeEach {
      reactor = .stub(shotID: ShotFixture.shot1.id)
      reactor.stub.isEnabled = true
      reactor.stub.state.value.shotSectionReactor.stub.isEnabled = true
      analytics = StubAnalytics()
      viewController = ShotViewController(
        reactor: reactor,
        analytics: analytics,
        shotSectionDelegateFactory: { .stub() }
      )
      _ = viewController.view
    }

    it("has subviews") {
      expect(viewController.refreshControl.superview) === viewController.collectionView
    }

    describe("a refresh control") {
      context("when initialized") {
        it("is not refreshing") {
          expect(viewController.refreshControl.isRefreshing) == false
        }
      }

      context("when refreshing") {
        it("is refreshing") {
          reactor.stub.state.value.isRefreshing = true
          expect(viewController.refreshControl.isRefreshing) == true
        }
      }
    }

    describe("a collection view") {
      it("has an image cell") {
        let cellReactor = ShotViewImageCellReactor(shot: ShotFixture.shot1)
        reactor.stub.state.value.shotSectionReactor.stub.state.value.sectionItems = [.image(cellReactor)]
        reactor.stub.state.value = reactor.stub.state.value
        expect(viewController.collectionView.cell(ShotViewImageCell.self, at: 0, 0)?.reactor) === cellReactor
        expect(viewController.collectionView.cell(ShotViewImageCell.self, at: 0, 0)?.dependency).notTo(beNil())
      }

      it("has a title cell") {
        let cellReactor = ShotViewTitleCellReactor(shot: ShotFixture.shot1)
        reactor.stub.state.value.shotSectionReactor.stub.state.value.sectionItems = [.title(cellReactor)]
        reactor.stub.state.value = reactor.stub.state.value
        expect(viewController.collectionView.cell(ShotViewTitleCell.self, at: 0, 0)?.reactor) === cellReactor
        expect(viewController.collectionView.cell(ShotViewTitleCell.self, at: 0, 0)?.dependency).notTo(beNil())
      }

      it("has a text cell") {
        let cellReactor = ShotViewTextCellReactor(shot: ShotFixture.shot1)
        reactor.stub.state.value.shotSectionReactor.stub.state.value.sectionItems = [.text(cellReactor)]
        reactor.stub.state.value = reactor.stub.state.value
        expect(viewController.collectionView.cell(ShotViewTextCell.self, at: 0, 0)?.reactor) === cellReactor
      }

      it("has a reaction cell") {
        let cellReactor = ShotViewReactionCellReactor.stub(shot: ShotFixture.shot1)
        reactor.stub.state.value.shotSectionReactor.stub.state.value.sectionItems = [.reaction(cellReactor)]
        reactor.stub.state.value = reactor.stub.state.value
        expect(viewController.collectionView.cell(ShotViewReactionCell.self, at: 0, 0)?.reactor) === cellReactor
      }

      it("has a comment cell") {
        let cellReactor = ShotViewCommentCellReactor(comment: CommentFixture.comment1)
        reactor.stub.state.value.commentSectionItems = [.comment(cellReactor)]
        expect(viewController.collectionView.cell(ShotViewCommentCell.self, at: 0, 0)?.reactor) === cellReactor
      }

      it("has an activity indicator cell") {
        reactor.stub.state.value.commentSectionItems = [.activityIndicator]
        expect(viewController.collectionView.cell(CollectionActivityIndicatorCell.self, at: 0, 0)).notTo(beNil())
      }
    }

    describe("an analytics") {
      context("when view did appear") {
        it("logs view shot event") {
          viewController.viewDidAppear(false)
          expect(analytics.events.last).to(match) {
            if case let .viewShot(shotID) = $0, shotID == ShotFixture.shot1.id {
              return true
            } else {
              return false
            }
          }
        }
      }
    }
  }
}
