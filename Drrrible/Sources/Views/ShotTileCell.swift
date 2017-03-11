//
//  ShotTileCell.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class ShotTileCell: BaseCollectionViewCell {

  // MARK: Constants

  fileprivate struct Metric {
    static let imageViewMargin = 6.f
  }


  // MARK: UI

  fileprivate let cardView = UIImageView().then {
    $0.image = UIImage.resizable()
      .border(color: .db_border)
      .border(width: 1 / UIScreen.main.scale)
      .corner(radius: 2)
      .color(.white)
      .image
  }
  fileprivate let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.cardView)
    self.cardView.addSubview(self.imageView)
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
    self.cardView.frame = self.contentView.bounds
    self.imageView.top = Metric.imageViewMargin
    self.imageView.left = Metric.imageViewMargin
    self.imageView.width = self.cardView.width - Metric.imageViewMargin * 2
    self.imageView.height = self.cardView.height - Metric.imageViewMargin * 2
  }

}
