//
//  ShotListViewReactorSpec.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 22/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest

import Nimble
import Quick
import Stubber

@testable import Drrrible

final class ShotListViewReactorSpec: QuickSpec {
  override func spec() {
    var shotService: StubShotService!
    var reactor: ShotListViewReactor!

    beforeEach {
      shotService = StubShotService()
      reactor = ShotListViewReactor(
        shotService: shotService,
        shotCellReactorFactory: ShotCellReactor.init
      )
    }

    describe("an initial state") {
      it("it not refreshing") {
        expect(reactor.currentState.isRefreshing) == false
      }

      it("is not loading") {
        expect(reactor.currentState.isLoading) == false
      }

      it("has no next page") {
        expect(reactor.currentState.nextURL).to(beNil())
      }

      it("has no items") {
        expect(reactor.currentState.sections[0].items.count) == 0
      }
    }

    context("when receives a refresh action") {
      it("fetches shots") {
        reactor.action.onNext(.refresh)
        expect(Stubber.executions(shotService.shots).count) == 1
        expect(Stubber.executions(shotService.shots)[0].arguments) == Paging.refresh
      }

      it("sets next url") {
      let nextURL = URL(string: "https://example.com")!
        Stubber.register(shotService.shots) { _ in
          let shots = [ShotFixture.shot1, ShotFixture.shot2]
          return .just(List<Shot>(items: shots, nextURL: nextURL))
        }
        reactor.action.onNext(.refresh)
        expect(reactor.currentState.nextURL) == nextURL
      }
    }

    context("when receives a load more action") {
      beforeEach {
        Stubber.register(shotService.shots) { paging in
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
        reactor.action.onNext(.refresh) // in order to set next url
        reactor.action.onNext(.loadMore)
      }

      it("fetches a next page") {
        expect(Stubber.executions(shotService.shots).count) == 2
        expect(Stubber.executions(shotService.shots)[1].arguments) == Paging.next(URL(string: "https://example.com?page=1")!)
      }

      it("sets next url") {
        expect(reactor.currentState.nextURL) == URL(string: "https://example.com?page=2")
      }
    }
  }
}
