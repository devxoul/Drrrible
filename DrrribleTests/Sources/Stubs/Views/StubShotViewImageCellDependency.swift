//
//  StubShotViewImageCellDependency.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

extension ShotViewImageCell.Dependency {
  static func stub(imageOptions: ImageOptions? = nil) -> ShotViewImageCell.Dependency {
    return .init(imageOptions: imageOptions ?? .stub())
  }
}
