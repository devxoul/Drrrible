//
//  ShotViewImageCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class ShotViewImageCell: BaseCollectionViewCell {

  // MARK: UI

  fileprivate let imageView = UIImageView()


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.imageView)
  }


  // MARK: Configuring

  func configure(cellModel: ShotViewImageCellModelType) {
    // Output
    self.imageView.kf.setImage(with: cellModel.imageViewURL)
  }


  // MARK: Size

  class func size(width: CGFloat, cellModel: ShotViewImageCellModelType) -> CGSize {
    return CGSize(width: width, height: ceil(width * 3 / 4))
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    self.imageView.frame = self.contentView.bounds
  }

}
