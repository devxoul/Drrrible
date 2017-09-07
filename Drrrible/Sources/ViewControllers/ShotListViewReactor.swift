//
//  ShotListViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class ShotListViewReactor: Reactor {
  enum Action {
    case refresh
    case loadMore
  }

  enum Mutation {
    case setRefreshing(Bool)
    case setLoading(Bool)
    case setShots([Shot], nextURL: URL?)
    case appendShots([Shot], nextURL: URL?)
  }

  struct State {
    var isRefreshing: Bool = false
    var isLoading: Bool = false
    var nextURL: URL?
    var sections: [ShotListViewSection] = [.shotTile([])]
  }

  let initialState = State()

  fileprivate let shotService: ShotServiceType
  fileprivate let shotCellReactorFactory: (Shot) -> ShotCellReactor

  init(
    shotService: ShotServiceType,
    shotCellReactorFactory: @escaping (Shot) -> ShotCellReactor
  ) {
    self.shotService = shotService
    self.shotCellReactorFactory = shotCellReactorFactory
    _ = self.state
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      guard !self.currentState.isRefreshing else { return .empty() }
      guard !self.currentState.isLoading else { return .empty() }
      let startRefreshing = Observable<Mutation>.just(.setRefreshing(true))
      let endRefreshing = Observable<Mutation>.just(.setRefreshing(false))
      let setShots = self.shotService.shots(paging: .refresh).asObservable()
        .map { list -> Mutation in
          return .setShots(list.items, nextURL: list.nextURL)
        }
      return .concat([startRefreshing, setShots, endRefreshing])

    case .loadMore:
      guard !self.currentState.isRefreshing else { return .empty() }
      guard !self.currentState.isLoading else { return .empty() }
      guard let nextURL = self.currentState.nextURL else { return .empty() }
      let startLoading = Observable<Mutation>.just(.setLoading(true))
      let endLoading = Observable<Mutation>.just(.setLoading(false))
      let appendShots = self.shotService.shots(paging: .next(nextURL)).asObservable()
        .map { list -> Mutation in
          return .appendShots(list.items, nextURL: list.nextURL)
        }
      return .concat([startLoading, appendShots, endLoading])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
      case let .setRefreshing(isRefreshing):
        // display the collection view's activity indicator only when the section is empty
        let isEmpty = state.sections.first?.items.isEmpty == true
        state.isRefreshing = isRefreshing && !isEmpty
        return state

      case let .setLoading(isLoading):
        state.isLoading = isLoading
        return state

      case let .setShots(shots, nextURL):
        let sectionItems = self.shotTileSectionItems(with: shots)
        state.sections = [.shotTile(sectionItems)]
        state.nextURL = nextURL
        return state

      case let .appendShots(shots, nextURL):
        let sectionItems = state.sections[0].items + self.shotTileSectionItems(with: shots)
        state.sections = [.shotTile(sectionItems)]
        state.nextURL = nextURL
        return state
    }
  }

  private func shotTileSectionItems(with shots: [Shot]) -> [ShotListViewSectionItem] {
    return shots
      .map(self.shotCellReactorFactory)
      .map(ShotListViewSectionItem.shotTile)
  }

}
