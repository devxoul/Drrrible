//
//  ShotViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxSwiftUtilities

final class ShotViewReactor: Reactor, ServiceContainer {
  enum Action {
    case refresh
  }

  enum Mutation {
    case setRefreshing(Bool)
    case setShot(Shot)
    case setComments([Comment])
  }

  struct State {
    let shotID: Int
    var isRefreshing: Bool = false
    var shotSection: ShotViewSection = .shot([])
    var commentSection: ShotViewSection = .comment([.activityIndicator])
    var sections: [ShotViewSection] {
      return [self.shotSection, self.commentSection]
    }
    init(shotID: Int) {
      self.shotID = shotID
    }
  }

  let initialState: State
  fileprivate var shotID: Int {
    return self.currentState.shotID
  }

  init(shotID: Int, shot initialShot: Shot? = nil) {
    var initialState = State(shotID: shotID)
    if let shot = initialShot {
      initialState.shotSection = ShotViewReactor.shotSection(from: shot)
    }
    self.initialState = initialState
    _ = self.state
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      guard !self.currentState.isRefreshing else { return .empty() }
      return Observable.concat([
        Observable.just(.setRefreshing(true)),
        self.shotService.shot(id: self.shotID).map(Mutation.setShot),
        Observable.just(.setRefreshing(false)),
        Observable.merge([
          self.shotService.isLiked(shotID: self.shotID).flatMap { _ in Observable.empty() },
          self.shotService.comments(shotID: self.shotID).map { Mutation.setComments($0.items) },
        ]),
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setRefreshing(isRefreshing):
      state.isRefreshing = isRefreshing
      return state

    case let .setShot(shot):
      state.shotSection = ShotViewReactor.shotSection(from: shot)
      return state

    case let .setComments(comments):
      let sectionItems = comments
        .map(ShotViewCommentCellReactor.init)
        .map(ShotViewSectionItem.comment)
      state.commentSection = .comment(sectionItems)
      return state
    }
  }

  private static func shotSection(from shot: Shot) -> ShotViewSection {
    let sectionItems: [ShotViewSectionItem] = [
      .image(ShotViewImageCellReactor(shot: shot)),
      .title(ShotViewTitleCellReactor(shot: shot)),
      .text(ShotViewTextCellReactor(shot: shot)),
      .reaction(ShotViewReactionCellReactor(shot: shot))
    ]
    return .shot(sectionItems)
  }
}
