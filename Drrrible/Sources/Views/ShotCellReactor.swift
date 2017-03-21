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
  var showShot: PublishSubject<Void> { get }

  // Output
  var imageURL: URL { get }
  var presentShotViewController: Observable<ShotViewReactorType> { get }
}

final class ShotCellReactor: ShotCellReactorType {

  // MARK: Input

  let showShot: PublishSubject<Void> = .init()


  // MARK: Output

  let imageURL: URL
  let presentShotViewController: Observable<ShotViewReactorType>


  // MARK: Initializing

  init(provider: ServiceProviderType, shot: Shot) {
    self.imageURL = shot.imageURLs.teaser
    self.presentShotViewController = self.showShot
      .map { ShotViewReactor(provider: provider, shotID: shot.id, shot: shot) }
  }

}
