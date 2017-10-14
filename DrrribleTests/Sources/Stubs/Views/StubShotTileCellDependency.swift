//
//  StubShotTileCellDependency.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 23/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Kingfisher
@testable import Drrrible

extension ShotTileCell.Dependency {
  static func stub(
    downloader: ImageDownloader? = nil,
    shotViewControllerFactory: ((_ id: Int, _ shot: Shot?) -> ShotViewController)? = nil
  ) -> ShotTileCell.Dependency {
    let downloader: ImageDownloader = downloader ?? StubImageDownloader()
    let shotViewControllerFactory = shotViewControllerFactory ?? { id, shot in
      let reactor = ShotViewReactor.stub(shotID: id, shot: shot)
      return ShotViewController(
        reactor: reactor,
        analytics: .stub(),
        shotSectionDelegateFactory: { .stub() }
      )
    }
    return .init(
      imageOptions: [.forceRefresh, .downloader(downloader)],
      navigator: StubNavigator(),
      shotViewControllerFactory: shotViewControllerFactory
    )
  }
}
