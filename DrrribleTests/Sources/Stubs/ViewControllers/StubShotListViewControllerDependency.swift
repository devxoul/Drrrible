//
//  StubShotListViewControllerDependency.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 16/08/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

extension ShotListViewController.Dependency {
  static func stub(
    analytics: DrrribleAnalytics? = nil,
    shotTileCellDependency: ShotTileCell.Dependency? = nil
  ) -> ShotListViewController.Dependency {
    return .init(
      analytics: analytics ?? StubAnalytics(),
      shotTileCellDependency: shotTileCellDependency ?? .stub()
    )
  }
}
