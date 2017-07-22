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
/*
final class ShotViewReactorTests: TestCase {
  func testIsRefreshing() {
    RxExpect { test in
      self.registerDependencies()
      let reactor = ShotViewReactor(shotID: 1)
      test.input(reactor.action, [
        next(100, .refresh),
        next(200, .refresh),
      ])
      test.assert(reactor.state.map { $0.isRefreshing }.distinctUntilChanged())
        .filterNext()
        .equal([
          false, // initial
          true,  // first refresh
          false, // refresh finish
          true,  // second refresh
          false, // refresh finish
        ])
    }
  }

  func testSections() {
    RxExpect { test in
      DI.register(ShotServiceType.self) { _ in
        MockShotService().then {
          $0.shotClosure = { _ in .just(ShotFixture.shot1) }
        }
      }
      let reactor = ShotViewReactor(shotID: 1)
      test.input(reactor.action, [
        next(100, .refresh),
      ])

      let isShotSectionItemsEmpty = reactor.state
        .map { $0.sections }
        .map { $0.first?.items.isEmpty ?? true }
        .distinctUntilChanged()
      test.assert(isShotSectionItemsEmpty)
        .filterNext()
        .equal([
          true,  // initial
          false, // after refresh
        ])
    }
  }
}
*/
