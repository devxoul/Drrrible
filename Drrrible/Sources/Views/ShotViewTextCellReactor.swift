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

  let initialState: State

  init(shot: Shot) {
    let text = shot.text.flatMap { try? NSAttributedString.init(htmlString: $0) }
    self.initialState = State(text: text)
    _ = self.state
  }
}
