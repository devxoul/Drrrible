//
//  StubShotViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 20/08/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

extension ShotViewReactor {
  static func stub(
    shotID: Int,
    shot initialShot: Shot? = nil,
    shotService: ShotServiceType? = nil,
    shotSectionReactorFactory: ((Int, Shot?) -> ShotSectionReactor)? = nil
  ) -> ShotViewReactor {
    return .init(
      shotID: shotID,
      shot: initialShot,
      shotService: shotService ?? StubShotService(),
      shotSectionReactorFactory: shotSectionReactorFactory ?? { shotID, shot in
        ShotSectionReactor.stub(shotID: shotID, shot: shot)
      }
    )
  }
}
