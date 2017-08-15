//
//  SettingItemCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class SettingItemCellReactor: Reactor {
  typealias Action = NoAction
  struct State {
    var text: String?
    var detailText: String?
  }

  let initialState: State

  init(text: String?, detailText: String?) {
    self.initialState = State(text: text, detailText: detailText)
    _ = self.state
  }
}
