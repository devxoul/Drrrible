//
//  ShotTileCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import URLNavigator

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

  func configure(reactor: ShotCellReactorType) {
    // Input
    self.cardView.rx.tapGesture() { $0.delegate = ExclusiveGestureRecognizerDelegate.shared }
      .mapVoid()
      .bindTo(reactor.backgroundDidTap)
      .addDisposableTo(self.disposeBag)

    // Output
    self.imageView.kf.setImage(with: reactor.imageViewURL, placeholder: nil)
    reactor.presentShotViewController
      .whileDisplaying(self)
      .subscribe(onNext: { reactor in
        Navigator.push(ShotViewController(reactor: reactor))
      })
      .addDisposableTo(self.disposeBag)
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotCellReactorType) -> CGSize {
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
