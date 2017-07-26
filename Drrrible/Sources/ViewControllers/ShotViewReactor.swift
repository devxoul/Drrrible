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

final class ShotViewReactor: Reactor {
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
    var shotSectionItems: [ShotViewSectionItem] = []
    var commentSectionItems: [ShotViewSectionItem] = [.activityIndicator]
    var sections: [ShotViewSection] {
      let sections: [ShotViewSection] = [
        .shot(self.shotSectionItems),
        .comment(self.commentSectionItems),
      ]
      return sections.filter { !$0.items.isEmpty }
    }
    init(shotID: Int) {
      self.shotID = shotID
    }
  }

  let initialState: State
  fileprivate var shotID: Int {
    return self.currentState.shotID
  }

  fileprivate let shotService: ShotServiceType

  init(shotID: Int, shot initialShot: Shot? = nil, shotService: ShotServiceType) {
    var initialState = State(shotID: shotID)
    if let shot = initialShot {
      initialState.shotSectionItems = [
        .image(ShotViewImageCellReactor(shot: shot)),
        .title(ShotViewTitleCellReactor(shot: shot)),
        .text(ShotViewTextCellReactor(shot: shot)),
        .reaction(ShotViewReactionCellReactor(shot: shot)),
      ]
    }
    self.initialState = initialState
    self.shotService = shotService
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
      state.shotSectionItems = [
        .image(ShotViewImageCellReactor(shot: shot)),
        .title(ShotViewTitleCellReactor(shot: shot)),
        .text(ShotViewTextCellReactor(shot: shot)),
        .reaction(ShotViewReactionCellReactor(shot: shot)),
      ]
      return state

    case let .setComments(comments):
      state.commentSectionItems = comments
        .map(ShotViewCommentCellReactor.init)
        .map(ShotViewSectionItem.comment)
      return state
    }
  }
}
