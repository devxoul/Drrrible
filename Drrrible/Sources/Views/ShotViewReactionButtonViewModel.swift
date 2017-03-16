//
//  ShotViewReactionButtonViewModel.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

enum ShotReactionType {
  case like
}

protocol ShotViewReactionButtonViewModelType {
  // Input
  var didDeallocate: PublishSubject<Void> { get }
  var buttonDidTap: PublishSubject<Void> { get }

  // Output
  var isButtonSelected: Bool { get }
  var isButtonUserInteractionEnabled: Bool { get }
  var labelText: String { get }
}
