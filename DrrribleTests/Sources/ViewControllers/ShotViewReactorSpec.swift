//
//  ShotViewReactorSpec.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 26/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Nimble
import Quick
import Stubber
@testable import Drrrible

final class ShotViewReactorSpec: QuickSpec {
  override func spec() {
    var shotService: StubShotService!

    beforeEach {
      shotService = StubShotService()
    }

    context("when receives a refresh action") {
      var reactor: ShotViewReactor!
      beforeEach {
        reactor = ShotViewReactor.stub(shotID: ShotFixture.shot1.id)
        reactor.action.onNext(.refresh)
      }

      it("fetches a shot") {
        expect(Stubber.executions(shotService.shot).count) == 1
        expect(Stubber.executions(shotService.shot)[0].arguments) == ShotFixture.shot1.id
      }

      it("fetches a like status") {
        expect(Stubber.executions(shotService.isLiked).count) == 1
        expect(Stubber.executions(shotService.isLiked)[0].arguments) == ShotFixture.shot1.id
      }

      it("fetches comments") {
        expect(Stubber.executions(shotService.comments).count) == 1
        expect(Stubber.executions(shotService.comments)[0].arguments) == ShotFixture.shot1.id
      }
    }

    describe("state.shotID") {
      context("when initialized") {
        it("is same with parameter") {
          let reactor = ShotViewReactor.stub(shotID: 123)
          expect(reactor.currentState.shotID) == 123
        }
      }
    }

    describe("state.isRefreshing") {
      context("when initialiezd") {
        it("is not refreshing") {
          let reactor = ShotViewReactor.stub(shotID: 123)
          expect(reactor.currentState.isRefreshing) == false
        }
      }

      context("while refreshing a shot") {
        it("is refreshing") {
          let reactor = ShotViewReactor.stub(shotID: ShotFixture.shot1.id)
          Stubber.register(shotService.shot) { _ in .never() }
          reactor.action.onNext(.refresh)
          expect(reactor.currentState.isRefreshing) == true
        }
      }

      context("while refreshing a like status") {
        it("is not refreshing") {
          let reactor = ShotViewReactor.stub(shotID: ShotFixture.shot1.id)
          Stubber.register(shotService.shot) { _ in .just(ShotFixture.shot1) }
          Stubber.register(shotService.isLiked) { _ in .never() }
          reactor.action.onNext(.refresh)
          expect(reactor.currentState.isRefreshing) == false
        }
      }

      context("while refreshing comments") {
        it("is not refreshing") {
          let reactor = ShotViewReactor.stub(shotID: ShotFixture.shot1.id)
          Stubber.register(shotService.shot) { _ in .just(ShotFixture.shot1) }
          Stubber.register(shotService.isLiked) { _ in .just(true) }
          Stubber.register(shotService.comments) { _ in .never() }
          reactor.action.onNext(.refresh)
          expect(reactor.currentState.isRefreshing) == false
        }
      }

      context("after refreshing") {
        it("is not refreshing") {
          let reactor = ShotViewReactor.stub(shotID: ShotFixture.shot1.id)
          Stubber.register(shotService.shot) { _ in .just(ShotFixture.shot1) }
          Stubber.register(shotService.isLiked) { _ in .just(true) }
          Stubber.register(shotService.comments) { _ in .just(List(items: [])) }
          reactor.action.onNext(.refresh)
          expect(reactor.currentState.isRefreshing) == false
        }
      }
    }

    describe("state.sections") {
      describe("a shot section") {
        func shotSection(from reactor: ShotViewReactor) -> ShotViewSection? {
          return reactor.currentState.sections.first {
            if case .shot = $0 {
              return true
            } else {
              return false
            }
          }
        }

        context("when initialized without a shot") {
          it("doesn't exist") {
            let reactor = ShotViewReactor.stub(shotID: ShotFixture.shot1.id)
            let section = shotSection(from: reactor)
            expect(section?.items).to(beNil())
          }
        }

        context("when initialized without a shot") {
          it("exists") {
            let reactor = ShotViewReactor.stub(shotID: ShotFixture.shot1.id, shot: ShotFixture.shot1)
            let section = shotSection(from: reactor)
            expect(section?.items).notTo(beEmpty())
          }
        }

        context("after refresh") {
          var reactor: ShotViewReactor!
          var section: ShotViewSection?

          beforeEach {
            Stubber.register(shotService.shot) { _ in .just(ShotFixture.shot1) }
            reactor = ShotViewReactor.stub(shotID: ShotFixture.shot1.id, shot: ShotFixture.shot1)
            section = shotSection(from: reactor)
          }

          it("contains an image item") {
            expect(section?.items).to(contain) {
              if case .shot(.image) = $0 {
                return true
              } else {
                return false
              }
            }
          }

          it("contains a title item") {
            expect(section?.items).to(contain) {
              if case .shot(.title) = $0 {
                return true
              } else {
                return false
              }
            }
          }

          it("contains a text item") {
            expect(section?.items).to(contain) {
              if case .shot(.text) = $0 {
                return true
              } else {
                return false
              }
            }
          }

          it("contains a reaction item") {
            expect(section?.items).to(contain) {
              if case .shot(.reaction) = $0 {
                return true
              } else {
                return false
              }
            }
          }
        }
      }

      describe("a comment section") {
        func commentSection(from reactor: ShotViewReactor) -> ShotViewSection? {
          return reactor.currentState.sections.first {
            if case .comment = $0 {
              return true
            } else {
              return false
            }
          }
        }

        context("when initialized") {
          it("has an activity indicator item") {
            let reactor = ShotViewReactor.stub(shotID: ShotFixture.shot1.id, shot: ShotFixture.shot1)
            let section = commentSection(from: reactor)
            expect(section?.items.count) == 1
            expect(section?.items).to(contain) {
              if case .activityIndicator = $0 {
                return true
              } else {
                return false
              }
            }
          }
        }

        context("after refresh") {
          var reactor: ShotViewReactor!

          beforeEach {
            Stubber.register(shotService.shot) { _ in .just(ShotFixture.shot1) }
            Stubber.register(shotService.isLiked) { _ in .just(true) }
            reactor = ShotViewReactor.stub(shotID: ShotFixture.shot1.id)
          }

          context("with no comments") {
            it("doesn't exist") {
              Stubber.register(shotService.comments) { _ in .just(List(items: [])) }
              reactor.action.onNext(.refresh)
              let section = commentSection(from: reactor)
              expect(section).to(beNil())
            }
          }

          context("with a single comment") {
            it("has a comment item") {
              Stubber.register(shotService.comments) { _ in
                let comments = [CommentFixture.comment1]
                return .just(List(items: comments))
              }
              reactor.action.onNext(.refresh)
              let section = commentSection(from: reactor)
              expect(section?.items.count) == 1
            }
          }

          context("with multiple comments") {
            it("has multiple comment items") {
              Stubber.register(shotService.comments) { _ in
                let comments = [CommentFixture.comment1, CommentFixture.comment2]
                return .just(List(items: comments))
              }
              reactor.action.onNext(.refresh)
              let section = commentSection(from: reactor)
              expect(section?.items.count) == 2
            }
          }
        }
      }
    }
  }
}
