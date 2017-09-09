//
//  ShotSectionReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift
import SectionReactor

final class ShotSectionReactor: SectionReactor {
  enum SectionItem {
    case image(ShotViewImageCellReactor)
    case title(ShotViewTitleCellReactor)
    case text(ShotViewTextCellReactor)
    case reaction(ShotViewReactionCellReactor)
  }
  
  enum Action {
    case updateShot(Shot)
  }

  enum Mutation {
    case setShot(Shot)
  }

  struct State: SectionReactorState {
    var sectionItems: [SectionItem] = []
  }

  let initialState: State
  fileprivate let reactionCellReactorFactory: (Shot) -> ShotViewReactionCellReactor

  init(
    shotID: Int,
    shot initialShot: Shot? = nil,
    reactionCellReactorFactory: @escaping (Shot) -> ShotViewReactionCellReactor
  ) {
    defer { _ = self.state }
    let sectionItems: [SectionItem]
    if let shot = initialShot {
      sectionItems = [
        .image(ShotViewImageCellReactor(shot: shot)),
        .title(ShotViewTitleCellReactor(shot: shot)),
        .text(ShotViewTextCellReactor(shot: shot)),
        .reaction(reactionCellReactorFactory(shot)),
      ]
    } else {
      sectionItems = []
    }
    self.initialState = State(sectionItems: sectionItems)
    self.reactionCellReactorFactory = reactionCellReactorFactory
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .updateShot(shot):
      return .just(.setShot(shot))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setShot(shot):
      state.sectionItems = [
        .image(ShotViewImageCellReactor(shot: shot)),
        .title(ShotViewTitleCellReactor(shot: shot)),
        .text(ShotViewTextCellReactor(shot: shot)),
        .reaction(self.reactionCellReactorFactory(shot)),
      ]
    }
    return state
  }
}
