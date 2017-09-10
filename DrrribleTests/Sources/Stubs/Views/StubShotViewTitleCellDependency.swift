//
//  StubShotViewTitleCellDependency.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

extension ShotViewTitleCell.Dependency {
  static func stub(imageOptions: ImageOptions? = nil) -> ShotViewTitleCell.Dependency {
    return .init(imageOptions: imageOptions ?? .stub())
  }
}
