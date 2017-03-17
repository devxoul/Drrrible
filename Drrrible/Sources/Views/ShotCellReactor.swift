//
//  ShotCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ShotCellReactorType {
  // Input
  var backgroundDidTap: PublishSubject<Void> { get }

  // Output
  var imageViewURL: URL { get }
  var presentShotViewController: Observable<ShotViewReactorType> { get }
}

final class ShotCellReactor: ShotCellReactorType {

  // MARK: Input

  let backgroundDidTap: PublishSubject<Void> = .init()


  // MARK: Output

  let imageViewURL: URL
  let presentShotViewController: Observable<ShotViewReactorType>


  // MARK: Initializing

  init(provider: ServiceProviderType, shot: Shot) {
    self.imageViewURL = shot.imageURLs.teaser
    self.presentShotViewController = self.backgroundDidTap
      .map { ShotViewReactor(provider: provider, shotID: shot.id, shot: shot) }
  }

}
