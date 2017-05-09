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
    var shotSection: ShotViewSection = .shot([])
    var commentSection: ShotViewSection = .comment([.activityIndicator])
    var sections: [ShotViewSection] {
      log.verbose(self.commentSection)
      return [self.shotSection, self.commentSection]
    }
    init(shotID: Int) {
      self.shotID = shotID
    }
  }

  fileprivate let provider: ServiceProviderType
  let initialState: State
  fileprivate var shotID: Int {
    return self.currentState.shotID
  }

  init(provider: ServiceProviderType, shotID: Int, shot initialShot: Shot? = nil) {
    self.provider = provider
    var initialState = State(shotID: shotID)
    if let shot = initialShot {
      initialState.shotSection = ShotViewReactor.shotSection(from: shot, provider: provider)
    }
    self.initialState = initialState
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      guard !self.currentState.isRefreshing else { return .empty() }
      return Observable.concat([
        Observable.just(.setRefreshing(true)),
        self.provider.shotService.shot(id: self.shotID).map(Mutation.setShot),
        Observable.just(.setRefreshing(false)),
        Observable.merge([
          self.provider.shotService.isLiked(shotID: self.shotID).flatMap { _ in Observable.empty() },
//          self.provider.shotService.comments(shotID: self.shotID).map { Mutation.setComments($0.items) },
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
      state.shotSection = ShotViewReactor.shotSection(from: shot, provider: self.provider)
      return state

    case let .setComments(comments):
      let sectionItems = comments
        .map { ShotViewCommentCellReactor(provider: self.provider, comment: $0) }
        .map { ShotViewSectionItem.comment($0) }
      state.commentSection = .comment(sectionItems)
      return state
    }
  }

  private static func shotSection(from shot: Shot, provider: ServiceProviderType) -> ShotViewSection {
    let sectionItems: [ShotViewSectionItem] = [
      .image(ShotViewImageCellReactor(provider: provider, shot: shot)),
      .title(ShotViewTitleCellReactor(provider: provider, shot: shot)),
      .text(ShotViewTextCellReactor(provider: provider, shot: shot)),
      .reaction(ShotViewReactionCellReactor(provider: provider, shot: shot))
    ]
    return .shot(sectionItems)
  }
}
