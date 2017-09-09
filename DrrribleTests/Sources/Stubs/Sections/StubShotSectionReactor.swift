//
//  StubShotSectionReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

extension ShotSectionReactor {
  static func stub(
    shotID: Int,
    shot initialShot: Shot? = nil,
    reactionCellReactorFactory: ((Shot) -> ShotViewReactionCellReactor)? = nil
  ) -> ShotSectionReactor {
    return .init(
      shotID: shotID,
      shot: initialShot,
      reactionCellReactorFactory: reactionCellReactorFactory ?? { shot in
        ShotViewReactionCellReactor.stub(shot: shot)
      }
    )
  }
}
