//
//  ShotListViewControllerTests.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 23/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest
@testable import Drrrible

final class ShotListViewControllerTests: TestCase {
  func testAction_refresh_viewDidLoad() {
    let reactor = ShotListViewReactor(
      shotService: StubShotService(),
      shotCellReactorFactory: ShotCellReactor.init
    )
    reactor.stub.isEnabled = true
    let viewController = ShotListViewController(reactor: reactor, shotTileCellDependency: .stub())
    _ = viewController.view // make viewDidLoad() gets called
    XCTAssertTrue({
      if case .refresh = reactor.stub.actions.last! {
        return true
      } else {
        return false
      }
    }())
  }

  func testAction_refresh_refreshControl() {
    let reactor = ShotListViewReactor(
      shotService: StubShotService(),
      shotCellReactorFactory: ShotCellReactor.init
    )
    reactor.stub.isEnabled = true
    let viewController = ShotListViewController(reactor: reactor, shotTileCellDependency: .stub())
    _ = viewController.view
    viewController.refreshControl.sendActions(for: .valueChanged)
    XCTAssertTrue({
      if case .refresh = reactor.stub.actions.last! {
        return true
      } else {
        return false
      }
    }())
  }

  func testAction_loadMore() {
    let reactor = ShotListViewReactor(
      shotService: StubShotService(),
      shotCellReactorFactory: ShotCellReactor.init
    )
    reactor.stub.isEnabled = true
    let viewController = ShotListViewController(reactor: reactor, shotTileCellDependency: .stub())
    _ = viewController.view
    viewController.collectionView.height = 100
    viewController.collectionView.contentSize.height = 300
    viewController.collectionView.contentOffset.y = 300
    viewController.collectionView.delegate?.scrollViewDidScroll?(viewController.collectionView)
    XCTAssertTrue({
      if case .loadMore = reactor.stub.actions.last! {
        return true
      } else {
        return false
      }
    }())
  }

  func testState_isRefreshing() {
    let reactor = ShotListViewReactor(
      shotService: StubShotService(),
      shotCellReactorFactory: ShotCellReactor.init
    )
    reactor.stub.isEnabled = true
    let viewController = ShotListViewController(reactor: reactor, shotTileCellDependency: .stub())
    _ = viewController.view
    reactor.stub.state.value.isRefreshing = true
    XCTAssertEqual(viewController.refreshControl.isRefreshing, true)
  }

  func testState_sections() {
    let reactor = ShotListViewReactor(
      shotService: StubShotService(),
      shotCellReactorFactory: ShotCellReactor.init
    )
    reactor.stub.isEnabled = true
    let viewController = ShotListViewController(reactor: reactor, shotTileCellDependency: .stub())
    _ = viewController.view
    let cellReactors = [ShotFixture.shot1, ShotFixture.shot2].map(ShotCellReactor.init)
    let sectionItems = cellReactors.map(ShotListViewSectionItem.shotTile)
    reactor.stub.state.value.sections = [.shotTile(sectionItems)]
    viewController.collectionView.do {
      XCTAssertEqual($0.dataSource?.collectionView($0, numberOfItemsInSection: 0), 2)
      XCTAssertTrue(
        ($0.dataSource?.collectionView($0, cellForItemAt: IndexPath(item: 0, section: 0)) as? ShotTileCell)?.reactor === cellReactors[0]
      )
      XCTAssertTrue(
        ($0.dataSource?.collectionView($0, cellForItemAt: IndexPath(item: 1, section: 0)) as? ShotTileCell)?.reactor === cellReactors[1]
      )
    }
  }
}
