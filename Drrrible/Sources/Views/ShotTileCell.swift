//
//  ShotTileCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import URLNavigator

final class ShotTileCell: BaseCollectionViewCell, View {

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

  func bind(reactor: ShotCellReactor) {
    // Action
    self.cardView.rx.tapGesture() { $0.delegate = ExclusiveGestureRecognizerDelegate.shared }
      .map { _ in Reactor.Action.showShot }
      .bindTo(reactor.action)
      .addDisposableTo(self.disposeBag)

    // State
    reactor.state.map { $0.imageURL }
      .subscribe(onNext: { [weak self] imageURL in
        self?.imageView.kf.setImage(with: imageURL, placeholder: nil)
      })
      .addDisposableTo(self.disposeBag)

    reactor.state.map { $0.navigation }
      .filterNil()
      .subscribe(onNext: { navigation in
        switch navigation {
        case let .shot(reactor):
          let viewController = ShotViewController(reactor: reactor)
          Navigator.push(viewController)
        }
      })
      .addDisposableTo(self.disposeBag)
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotCellReactor) -> CGSize {
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
