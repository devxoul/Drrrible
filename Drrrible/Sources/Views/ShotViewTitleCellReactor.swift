//
//  ShotViewTitleCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class ShotViewTitleCellReactor: Reactor {
  typealias Action = NoAction
  
  struct State {
    var avatarURL: URL?
    var title: String
    var username: String
  }

  fileprivate let provider: ServiceProviderType
  let initialState: State

  init(provider: ServiceProviderType, shot: Shot) {
    self.provider = provider
    self.initialState = State(
      avatarURL: shot.user.avatarURL,
      title: shot.title,
      username: "by \(shot.user.name)"
    )
  }
}
