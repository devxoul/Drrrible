//
//  ShotViewReactorTests.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 22/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest

import RxCocoa
import RxExpect
import RxSwift
import RxTest

@testable import Drrrible

final class ShotListViewReactorTests: TestCase {
  func testInitialState() {
    let reactor = ShotListViewReactor(
      shotService: StubShotService(),
      shotCellReactorFactory: ShotCellReactor.init
    )
    XCTAssertEqual(reactor.currentState.isRefreshing, false)
    XCTAssertEqual(reactor.currentState.isLoading, false)
    XCTAssertEqual(reactor.currentState.nextURL, nil)
    XCTAssertEqual(reactor.currentState.sections[0].items.count, 0)
  }

  func testRefresh() {
    let nextURL = URL(string: "https://example.com")!
    let shotService = StubShotService().then {
      $0.stub($0.shots) { _ in
        let shots = [ShotFixture.shot1, ShotFixture.shot2]
        return .just(List<Shot>(items: shots, nextURL: nextURL))
      }
    }
    let reactor = ShotListViewReactor(
      shotService: shotService,
      shotCellReactorFactory: ShotCellReactor.init
    )
    _ = reactor.state
    reactor.action.onNext(.refresh)
    let executions = shotService.executions(shotService.shots)
    XCTAssertEqual(executions.count, 1)
    XCTAssertEqual(executions[0].arguments, .refresh)
    XCTAssertEqual(reactor.currentState.sections[0].items.count, 2)
    XCTAssertEqual(reactor.currentState.nextURL, nextURL)
  }

  func testLoadMore() {
    let shotService = StubShotService().then {
      $0.stub($0.shots) { paging in
        switch paging {
        case .refresh:
          let shots = [ShotFixture.shot1]
          let nextURL = URL(string: "https://example.com?page=1")!
          return .just(List<Shot>(items: shots, nextURL: nextURL))

        case .next:
          let shots = [ShotFixture.shot2]
          let nextURL = URL(string: "https://example.com?page=2")!
          return .just(List<Shot>(items: shots, nextURL: nextURL))
        }
      }
    }
    let reactor = ShotListViewReactor(
      shotService: shotService,
      shotCellReactorFactory: ShotCellReactor.init
    )
    _ = reactor.state
    reactor.action.onNext(.refresh) // to set next url
    reactor.action.onNext(.loadMore)
    let executions = shotService.executions(shotService.shots)
    XCTAssertEqual(executions.count, 2)
    XCTAssertEqual(executions[1].arguments, .next(URL(string: "https://example.com?page=1")!))
    XCTAssertEqual(reactor.currentState.sections[0].items.count, 2)
    XCTAssertEqual(reactor.currentState.nextURL, URL(string: "https://example.com?page=2")!)
  }
}
