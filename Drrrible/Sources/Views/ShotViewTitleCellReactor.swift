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

struct ShotViewTitleCellComponents: ReactorComponents {
  struct State {
    var avatarURL: URL?
    var title: String
    var username: String
  }
}

final class ShotViewTitleCellReactor: Reactor<ShotViewTitleCellComponents> {
  fileprivate let provider: ServiceProviderType

  init(provider: ServiceProviderType, shot: Shot) {
    self.provider = provider
    let initialState = State(
      avatarURL: shot.user.avatarURL,
      title: shot.title,
      username: "by \(shot.user.name)"
    )
    super.init(initialState: initialState)
  }
}
