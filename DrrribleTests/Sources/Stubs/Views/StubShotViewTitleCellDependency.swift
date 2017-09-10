//
//  StubShotViewTitleCellDependency.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Kingfisher
@testable import Drrrible

extension ShotViewTitleCell.Dependency {
  static func stub(imageOptions: KingfisherOptionsInfo? = nil) -> ShotViewTitleCell.Dependency {
    return .init(imageOptions: imageOptions ?? .stub())
  }
}
