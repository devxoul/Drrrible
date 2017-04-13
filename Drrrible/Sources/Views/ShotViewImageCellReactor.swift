//
//  ShotViewImageCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

struct ShotViewImageCellComponents: ReactorComponents {
  struct State {
    var imageURL: URL
  }
}

final class ShotViewImageCellReactor: Reactor<ShotViewImageCellComponents> {
  fileprivate let provider: ServiceProviderType

  init(provider: ServiceProviderType, shot: Shot) {
    self.provider = provider
    let initialState = State(imageURL: shot.imageURLs.hidpi ?? shot.imageURLs.normal)
    super.init(initialState: initialState)
  }
}
