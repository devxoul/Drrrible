//
//  ShotListViewControllerSpec.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 23/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Nimble
import Quick
@testable import Drrrible

final class ShotListViewControllerSpec: QuickSpec {
  override func spec() {
    var reactor: ShotListViewReactor!
    var viewController: ShotListViewController!

    beforeEach {
      reactor = ShotListViewReactor(
        shotService: StubShotService(),
        shotCellReactorFactory: ShotCellReactor.init
      )
      reactor.stub.isEnabled = true
      viewController = ShotListViewController(
        reactor: reactor,
        analytics: .stub(),
        shotTileCellDependency: .stub()
      )
      _ = viewController.view // make viewDidLoad() gets called
    }

    describe("a view") {
      context("when loaded") {
        it("sends a refresh action") {
          expect(reactor.stub.actions.last).to(match) {
            if case .refresh = $0 {
              return true
            } else {
              return false
            }
          }
        }
      }
    }

    describe("a refresh control") {
      context("when triggers") {
        it("sends a refresh action") {
          viewController.refreshControl.sendActions(for: .valueChanged)
          expect(reactor.stub.actions.last).to(match) {
            if case .refresh = $0 {
              return true
            } else {
              return false
            }
          }
        }
      }

      context("when refreshing state") {
        it("is refreshing") {
          reactor.stub.state.value.isRefreshing = true
          expect(viewController.refreshControl.isRefreshing) == true
        }
      }
    }

    describe("a collection view") {
      context("when scrolls to bottom") {
        it("sends a load more action") {
          viewController.collectionView.height = 100
          viewController.collectionView.contentSize.height = 300
          viewController.collectionView.contentOffset.y = 300
          viewController.collectionView.delegate?.scrollViewDidScroll?(viewController.collectionView)
          expect(reactor.stub.actions.last).to(match) {
            if case .loadMore = $0 {
              return true
            } else {
              return false
            }
          }
        }
      }

      context("when sections have shotTiles") {
        it("has shot tile cells") {
          let cellReactors = [ShotFixture.shot1, ShotFixture.shot2].map(ShotCellReactor.init)
          let sectionItems = cellReactors.map(ShotListViewSectionItem.shotTile)
          reactor.stub.state.value.sections = [.shotTile(sectionItems)]
          expect(viewController.collectionView.cell(ShotTileCell.self, at: 0, 0)?.reactor) === cellReactors[0]
          expect(viewController.collectionView.cell(ShotTileCell.self, at: 0, 1)?.reactor) === cellReactors[1]
        }
      }
    }
  }
}
