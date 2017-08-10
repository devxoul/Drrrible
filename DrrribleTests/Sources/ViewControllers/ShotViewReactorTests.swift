//
//  ShotViewReactorTests.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 26/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest
import RxTest
import Stubber
@testable import Drrrible

final class ShotViewReactorTests: TestCase {
  func testInitialState_shotID() {
    let reactor = ShotViewReactor(
      shotID: 123,
      shotService: StubShotService()
    )
    XCTAssertEqual(reactor.currentState.shotID, 123)
    XCTAssertEqual(reactor.currentState.isRefreshing, false)
  }

  func testInitialState_shot() {
    let reactor = ShotViewReactor(
      shotID: ShotFixture.shot1.id,
      shot: ShotFixture.shot1,
      shotService: StubShotService()
    )
    XCTAssertEqual(reactor.currentState.shotID, ShotFixture.shot1.id)
    let shotSection = reactor.currentState.sections.lazy
      .filter {
        guard case .shot = $0 else { return false }
        return true
      }
      .first
    XCTAssertNotNil(shotSection)
    XCTAssertEqual(shotSection?.items.isEmpty, false)
  }

  func testRefresh_service() {
    let shotService = StubShotService()
    Stubber.stub(shotService.shot) { _ in .empty() }
    Stubber.stub(shotService.isLiked) { _ in .empty() }
    Stubber.stub(shotService.comments) { _ in .empty() }
    let reactor = ShotViewReactor(
      shotID: ShotFixture.shot1.id,
      shotService: shotService
    )
    _ = reactor.state
    reactor.action.onNext(.refresh)
    XCTAssertEqual(Stubber.executions(shotService.shot).count, 1)
    XCTAssertEqual(Stubber.executions(shotService.shot)[0].arguments, ShotFixture.shot1.id)
    XCTAssertEqual(Stubber.executions(shotService.isLiked).count, 1)
    XCTAssertEqual(Stubber.executions(shotService.isLiked)[0].arguments, ShotFixture.shot1.id)
    XCTAssertEqual(Stubber.executions(shotService.comments).count, 1)
    XCTAssertEqual(Stubber.executions(shotService.comments)[0].arguments, ShotFixture.shot1.id)
  }

  func testIsRefreshing() {
    RxExpect { test in
      let shotService = StubShotService()
      Stubber.stub(shotService.shot) { _ in .just(ShotFixture.shot1) }
      Stubber.stub(shotService.isLiked) { _ in .just(true) }
      Stubber.stub(shotService.comments) { _ in .just(List(items: [])) }
      let reactor = ShotViewReactor(
        shotID: ShotFixture.shot1.id,
        shotService: shotService
      )
      test.retain(reactor)
      test.input(reactor.action, [
        next(100, .refresh)
      ])
      let isRefreshing = reactor.state.map { $0.isRefreshing }.distinctUntilChanged()
      test.assert(isRefreshing)
        .equal([
          false, // initial value
          true,
          false,
        ])
    }
  }

  func testSections_shot() {
    let shotService = StubShotService()
    Stubber.stub(shotService.shot) { _ in .just(ShotFixture.shot1) }
    Stubber.stub(shotService.isLiked) { _ in .just(true) }
    Stubber.stub(shotService.comments) { _ in .just(List(items: [])) }
    let reactor = ShotViewReactor(
      shotID: ShotFixture.shot1.id,
      shotService: shotService
    )
    _ = reactor.state
    reactor.action.onNext(.refresh)
    let shotSection = reactor.currentState.sections.lazy
      .filter {
        guard case .shot = $0 else { return false }
        return true
      }
      .first
    XCTAssertNotNil(shotSection)
    XCTAssertNotNil(
      shotSection?.items.lazy
        .filter {
          guard case .image = $0 else { return false }
          return true
        }
        .first
    )
    XCTAssertNotNil(
      shotSection?.items.lazy
        .filter {
          guard case .title = $0 else { return false }
          return true
        }
        .first
    )
    XCTAssertNotNil(
      shotSection?.items.lazy
        .filter {
          guard case .text = $0 else { return false }
          return true
        }
        .first
    )
    XCTAssertNotNil(
      shotSection?.items.lazy
        .filter {
          guard case .reaction = $0 else { return false }
          return true
        }
        .first
    )
  }

  func testSections_comment_empty() {
    let shotService = StubShotService()
    Stubber.stub(shotService.shot) { _ in .just(ShotFixture.shot1) }
    Stubber.stub(shotService.isLiked) { _ in .never() }
    Stubber.stub(shotService.comments) { _ in .just(List(items: [])) }
    let reactor = ShotViewReactor(
      shotID: ShotFixture.shot1.id,
      shotService: shotService
    )
    _ = reactor.state
    reactor.action.onNext(.refresh)
    let commentSection = reactor.currentState.sections.lazy
      .filter {
        guard case .comment = $0 else { return false }
        return true
      }
      .first
    XCTAssertNil(commentSection)
  }

  func testSections_comment_1() {
    let shotService = StubShotService()
    Stubber.stub(shotService.shot) { _ in .just(ShotFixture.shot1) }
    Stubber.stub(shotService.isLiked) { _ in .just(true) }
    Stubber.stub(shotService.comments) { _ in
      return .just(List(items: [CommentFixture.comment1]))
    }
    let reactor = ShotViewReactor(
      shotID: ShotFixture.shot1.id,
      shotService: shotService
    )
    _ = reactor.state
    reactor.action.onNext(.refresh)
    let commentSection = reactor.currentState.sections.lazy
      .filter {
        guard case .comment = $0 else { return false }
        return true
      }
      .first
    XCTAssertNotNil(commentSection)
    XCTAssertEqual(commentSection?.items.count, 1)
  }

  func testSections_comment_2() {
    let shotService = StubShotService()
    Stubber.stub(shotService.shot) { _ in .just(ShotFixture.shot1) }
    Stubber.stub(shotService.isLiked) { _ in .never() }
    Stubber.stub(shotService.comments) { _ in
      return .just(List(items: [CommentFixture.comment1, CommentFixture.comment2]))
    }
    let reactor = ShotViewReactor(
      shotID: ShotFixture.shot1.id,
      shotService: shotService
    )
    _ = reactor.state
    reactor.action.onNext(.refresh)
    let commentSection = reactor.currentState.sections.lazy
      .filter {
        guard case .comment = $0 else { return false }
        return true
      }
      .first
    XCTAssertNotNil(commentSection)
    XCTAssertEqual(commentSection?.items.count, 2)
  }
}
