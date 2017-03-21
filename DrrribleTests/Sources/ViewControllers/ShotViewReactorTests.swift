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

final class ShotViewReactorTests: XCTestCase {

  func testIsRefreshing() {
    RxExpect { test in
      let provider = MockServiceProvider()
      let reactor = ShotViewReactor(provider: provider, shotID: 1)
      test.input(reactor.refresh, [
        next(100, Void()),
        next(200, Void()),
      ])
      test.assert(reactor.isRefreshing)
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
      let provider = MockServiceProvider()
      provider.shotService = MockShotService(provider: provider).then {
        $0.shotClosure = { _ in .just(ShotFixture.shot1) }
      }
      let reactor = ShotViewReactor(provider: provider, shotID: 1)
      test.input(reactor.refresh, [
        next(100, Void()),
      ])

      let isShotSectionItemsEmpty = reactor.sections.map { $0.first?.items.isEmpty ?? true }
      test.assert(isShotSectionItemsEmpty)
        .filterNext()
        .equal([
          true,  // initial
          false, // after refresh
        ])
    }
  }

}
