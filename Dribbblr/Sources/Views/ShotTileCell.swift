//
//  ShotTileCell.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class ShotTileCell: BaseCollectionViewCell {

  // MARK: UI

  fileprivate let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.contentView.addSubview(self.imageView)
  }


  // MARK: Configuring

  func configure(cellModel: ShotCellModelType) {
    self.imageView.kf.setImage(with: cellModel.imageViewURL, placeholder: nil)
  }


  // MARK: Size

  class func size(width: CGFloat, cellModel: ShotCellModelType) -> CGSize {
    return CGSize(width: width, height: ceil(width * 3 / 4))
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    self.imageView.frame = self.contentView.bounds
  }

}
