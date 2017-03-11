//
//  ShotCellModel.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ShotCellModelType {
  // Input
  var backgroundDidTap: PublishSubject<Void> { get }

  // Output
  var imageViewURL: URL { get }
  var presentShotViewController: Observable<ShotViewModelType> { get }
}

final class ShotCellModel: ShotCellModelType {

  // MARK: Input

  let backgroundDidTap: PublishSubject<Void> = .init()


  // MARK: Output

  let imageViewURL: URL
  let presentShotViewController: Observable<ShotViewModelType>


  // MARK: Initializing

  init(provider: ServiceProviderType, shot: Shot) {
    self.imageViewURL = shot.imageURLs.teaser
    self.presentShotViewController = self.backgroundDidTap
      .map { ShotViewModel(provider: provider, shotID: shot.id, shot: shot) }
  }

}
