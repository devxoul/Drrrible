//
//  BaseCollectionViewCell.swift
//  Dribbble
//
//  Created by Suyeol Jeon on 10/02/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {

  var disposeBag = DisposeBag()
  

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init(frame: .zero)
  }

}
