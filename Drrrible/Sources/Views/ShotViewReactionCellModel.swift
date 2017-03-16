//
//  ShotViewReactionCellModel.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

protocol ShotViewReactionCellModelType: class {
  var likeButtonViewModel: ShotViewReactionButtonViewModelType { get }
  var commentButtonViewModel: ShotViewReactionButtonViewModelType { get }
}

final class ShotViewReactionCellModel: ShotViewReactionCellModelType {

  let likeButtonViewModel: ShotViewReactionButtonViewModelType
  let commentButtonViewModel: ShotViewReactionButtonViewModelType

  init(provider: ServiceProviderType, shot: Shot) {
    self.likeButtonViewModel = ShotViewReactionLikeButtonViewModel(provider: provider, shot: shot)
    self.commentButtonViewModel = ShotViewReactionCommentButtonViewModel(provider: provider, shot: shot)
  }

}
