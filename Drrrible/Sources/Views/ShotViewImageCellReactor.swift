//
//  ShotViewImageCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ShotViewImageCellReactorType {
  // Output
  var imageURL: URL { get }
}

final class ShotViewImageCellReactor: ShotViewImageCellReactorType {

  // MARK: Output

  let imageURL: URL


  // MARK: Initializing

  init(provider: ServiceProviderType, shot: Shot) {
    self.imageURL = shot.imageURLs.hidpi ?? shot.imageURLs.normal
  }

}
