//
//  ShotViewReactionCellModel.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

protocol ShotViewReactionCellModelType: class {
  var likeButtonViewReactor: ShotViewReactionButtonViewReactorType { get }
  var commentButtonViewReactor: ShotViewReactionButtonViewReactorType { get }
}

final class ShotViewReactionCellModel: ShotViewReactionCellModelType {

  let likeButtonViewReactor: ShotViewReactionButtonViewReactorType
  let commentButtonViewReactor: ShotViewReactionButtonViewReactorType

  init(provider: ServiceProviderType, shot: Shot) {
    self.likeButtonViewReactor = ShotViewReactionLikeButtonViewReactor(provider: provider, shot: shot)
    self.commentButtonViewReactor = ShotViewReactionCommentButtonViewReactor(provider: provider, shot: shot)
  }

}
