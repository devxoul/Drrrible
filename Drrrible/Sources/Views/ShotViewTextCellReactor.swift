//
//  ShotViewTextCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit

final class ShotViewTextCellReactor: Reactor {
  typealias Action = NoAction
  
  struct State {
    var text: NSAttributedString?
  }

  fileprivate let provider: ServiceProviderType
  let initialState: State

  init(provider: ServiceProviderType, shot: Shot) {
    self.provider = provider
    let text = shot.text.flatMap { try? NSAttributedString.init(htmlString: $0) }
    self.initialState = State(text: text)
  }
}
