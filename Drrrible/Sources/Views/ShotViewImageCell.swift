//
//  ShotViewImageCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit

final class ShotViewImageCell: BaseCollectionViewCell, View {

  // MARK: UI

  fileprivate let imageView = UIImageView()


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.imageView)
  }


  // MARK: Configuring

  func configure(reactor: ShotViewImageCellReactor) {
    reactor.state.map { $0.imageURL }
      .subscribe(onNext: { [weak self] imageURL in
        self?.imageView.kf.setImage(with: imageURL)
      })
      .addDisposableTo(self.disposeBag)
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotViewImageCellReactor) -> CGSize {
    return CGSize(width: width, height: ceil(width * 3 / 4))
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    self.imageView.frame = self.contentView.bounds
  }

}
