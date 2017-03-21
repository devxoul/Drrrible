//
//  ShotListViewReactorTests.swift
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

final class ShotListViewReactorTests: XCTestCase {

  func testIsRefreshing() {
    RxExpect() { test in
      let provider = MockServiceProvider()
      let reactor = ShotListViewReactor(provider: provider)
      test.input(reactor.refresh, [
        next(100, Void()),
      ])
      test.assert(reactor.isRefreshing)
        .filterNext()
        .equal([
          false,
          true,
          false,
        ])
    }
  }

  func testSections() {
    RxExpect { test in
      let provider = MockServiceProvider()
      provider.shotService = MockShotService(provider: provider).then {
        $0.shotsClosure = { _ in
          .just(List(items: [ShotFixture.shot1, ShotFixture.shot2]))
        }
      }

      let reactor = ShotListViewReactor(provider: provider)
      test.input(reactor.refresh, [
        next(100, Void()),
      ])

      let sectionItemCount = reactor.sections.map { $0[0].items.count }
      test.assert(sectionItemCount)
        .filterNext()
        .equal([
          0, // initial
          2, // after refreshing
        ])
    }
  }

}
