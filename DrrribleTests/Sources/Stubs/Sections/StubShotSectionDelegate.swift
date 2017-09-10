//
//  StubShotSectionDelegate.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

extension ShotSectionDelegate {
  static func stub(
    imageCellDependency: ShotViewImageCell.Dependency? = nil,
    titleCellDependency: ShotViewTitleCell.Dependency? = nil
  ) -> ShotSectionDelegate {
    return ShotSectionDelegate(
      imageCellDependency: imageCellDependency ?? .stub(),
      titleCellDependency: titleCellDependency ?? .stub()
    )
  }
}
