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
  // Output
  var imageViewURL: URL { get }
}

final class ShotCellModel: ShotCellModelType {

  // MARK: Output

  let imageViewURL: URL


  // MARK: Initializing

  init(provider: ServiceProviderType, shot: Shot) {
    self.imageViewURL = shot.imageURLs.teaser
  }

}
