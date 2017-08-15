//
//  ShotViewReactionButtonViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

class ShotViewReactionButtonViewReactor: Reactor {
  enum Action {
    case toggleReaction
  }

  enum Mutation {
    case setReacted(Bool)
    case setCanToggleReaction(Bool)
    case setCount(Int)
  }

  struct State {
    let shotID: Int
    var isReacted: Bool?
    var canToggleReaction: Bool
    var count: Int
  }

  let initialState: State
  var shotID: Int {
    return self.currentState.shotID
  }

  init(initialState: State) {
    self.initialState = initialState
    _ = self.state
  }

  func mutate(action: Action) -> Observable<Mutation> {
    return .empty()
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let fromShotEvent = Shot.event.flatMap { [weak self] event in
      self?.mutation(from: event) ?? .empty()
    }
    return Observable.of(mutation, fromShotEvent).merge()
  }

  func mutation(from event: Shot.Event) -> Observable<Mutation> {
    return .empty()
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setReacted(isReacted):
      state.isReacted = isReacted
      return state

    case let .setCanToggleReaction(canToggleReaction):
      state.canToggleReaction = canToggleReaction
      return state

    case let .setCount(count):
      state.count = count
      return state
    }
  }
}
