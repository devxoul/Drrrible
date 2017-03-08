//
//  ShotsViewModel.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

// MARK: - Input

protocol ShotsViewModelInput {
}


// MARK: - Output

protocol ShotsViewModelOutput {
}


// MARK: - ViewModel

typealias ShotsViewModelType = ShotsViewModelInput & ShotsViewModelOutput
final class ShotsViewModel: ShotsViewModelType {

  // MARK: Initializing

  init(provider: ServiceProviderType) {
  }

}
