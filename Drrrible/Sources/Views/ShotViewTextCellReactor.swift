//
//  ShotViewTextCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit

struct ShotViewTextCellComponents: ReactorComponents {
  struct State {
    var text: NSAttributedString?
  }
}

final class ShotViewTextCellReactor: Reactor<ShotViewTextCellComponents> {
  fileprivate let provider: ServiceProviderType

  init(provider: ServiceProviderType, shot: Shot) {
    self.provider = provider
    let text = shot.text.flatMap { try? NSAttributedString.init(htmlString: $0) }
    let initialState = State(text: text)
    super.init(initialState: initialState)
  }
}
