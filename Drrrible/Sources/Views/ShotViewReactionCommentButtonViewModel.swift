//
//  ShotViewReactionCommentButtonViewModel.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

final class ShotViewReactionCommentButtonViewModel: ShotViewReactionButtonViewModelType {

  // MARK: Input

  let didDeallocate: PublishSubject<Void> = .init()
  let buttonDidTap: PublishSubject<Void> = .init()


  // MARK: Output

  let isButtonSelected: Bool
  let isButtonUserInteractionEnabled: Bool
  let labelText: String


  // MARK: Initializing

  init(provider: ServiceProviderType, shot: Shot) {
    self.isButtonSelected = false
    self.isButtonUserInteractionEnabled = true
    self.labelText = "\(shot.commentCount)"
  }

}
