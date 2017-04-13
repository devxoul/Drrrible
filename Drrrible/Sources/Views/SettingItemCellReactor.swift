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

struct SettingItemCellComponents: ReactorComponents {
  struct State {
    var text: String?
    var detailText: String?
  }
}

final class SettingItemCellReactor: Reactor<SettingItemCellComponents> {
  init(text: String?, detailText: String?) {
    super.init(initialState: State(text: text, detailText: detailText))
  }
}
