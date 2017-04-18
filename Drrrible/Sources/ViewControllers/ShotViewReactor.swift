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
    case shotEvent(Shot.Event)
  }

  enum Mutation {
    case setRefreshing(Bool)
    case setShot(Shot?)
    case setLiked(Bool)
    case setComments([Comment])
  }

  struct State {
    var isRefreshing: Bool = false
    var shot: Shot?

    var shotSection: ShotViewSection = .shot([])
    var commentSection: ShotViewSection = .comment([.activityIndicator])
    var sections: [ShotViewSection] {
      return [self.shotSection, self.commentSection]
    }
  }

  fileprivate let provider: ServiceProviderType
  fileprivate let shotID: Int
  let initialState: State

  init(provider: ServiceProviderType, shotID: Int, shot initialShot: Shot? = nil) {
    self.provider = provider
    self.shotID = shotID
    self.initialState = State()
  }

  func transform(action: Observable<Action>) -> Observable<Action> {
    let shotEvent: Observable<Action> = Shot.event.map(Action.shotEvent)
    return Observable.of(action, shotEvent).merge()
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      guard !self.currentState.isRefreshing else { return .empty() }
      let startRefreshing: Observable<Mutation> = .just(.setRefreshing(true))
      let stopRefreshing: Observable<Mutation> = .just(.setRefreshing(false))
      let setShot: Observable<Mutation> = self.provider.shotService
        .shot(id: self.shotID)
        .map { shot in Mutation.setShot(shot) }

      let setLiked: Observable<Mutation> = self.provider.shotService
        .isLiked(shotID: self.shotID)
        .map { isLiked in Mutation.setLiked(isLiked) }

      let setComments: Observable<Mutation> = self.provider.shotService
        .comments(shotID: self.shotID)
        .map { list in .setComments(list.items) }

      let main = Observable.concat([startRefreshing, setShot, stopRefreshing])
      let sub = Observable.of(setLiked, setComments).merge()
      return .concat([main, sub])

    case let .shotEvent(event):
      return self.mutate(shotEvent: event)
    }
  }

  private func mutate(shotEvent: Shot.Event) -> Observable<Mutation> {
    switch shotEvent {
    case let .create(shot):
      guard shot.id == self.shotID else { return .empty() }
      return .just(.setShot(shot))

    case let .update(shot):
      guard shot.id == self.shotID else { return .empty() }
      return .just(.setShot(shot))

    case let .delete(id):
      guard id == self.shotID else { return .empty() }
      return .just(.setShot(nil))

    case let .like(id):
      guard id == self.shotID else { return .empty() }
      return .just(.setLiked(true))

    case let .unlike(id):
      guard id == self.shotID else { return .empty() }
      return .just(.setLiked(false))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setRefreshing(isRefreshing):
      state.isRefreshing = isRefreshing
      return state

    case let .setShot(shot):
      guard let shot = shot else {
        state.shotSection = .shot([])
        state.shot = nil
        return state
      }
      let sectionItems: [ShotViewSectionItem] = [
        .image(ShotViewImageCellReactor(provider: self.provider, shot: shot)),
        .title(ShotViewTitleCellReactor(provider: self.provider, shot: shot)),
        .text(ShotViewTextCellReactor(provider: self.provider, shot: shot)),
        .reaction(ShotViewReactionCellReactor(provider: self.provider, shot: shot))
      ]
      state.shotSection = .shot(sectionItems)
      state.shot = shot
      return state

    case let .setLiked(isLiked):
      guard var shot = state.shot else { return state }
      if isLiked && shot.isLiked != true {
        shot.isLiked = true
        shot.likeCount += 1
      } else if !isLiked && shot.isLiked != false {
        shot.isLiked = false
        shot.likeCount -= 1
      } else {
        return state
      }
      return self.reduce(state: state, mutation: .setShot(shot))

    case let .setComments(comments):
      let sectionItems = comments
        .map { ShotViewCommentCellReactor(provider: self.provider, comment: $0) }
        .map { ShotViewSectionItem.comment($0) }
      state.commentSection = .comment(sectionItems)
      return state
    }
  }

}
