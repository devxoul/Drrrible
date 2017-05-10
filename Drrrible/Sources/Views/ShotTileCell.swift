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
    // State
    reactor.state.map { $0.imageURL }
      .bind(to: self.imageView.rx.resource)
      .disposed(by: self.disposeBag)

    // View
    self.cardView.rx.tapGesture() { $0.delegate = ExclusiveGestureRecognizerDelegate.shared }
      .whileDisplaying(self)
      .subscribe(onNext: { [weak reactor] _ in
        guard let reactor = reactor else { return }
        let nextReactor = ShotViewReactor(shotID: reactor.shot.id, shot: reactor.shot)
        let viewController = ShotViewController(reactor: nextReactor)
        Navigator.push(viewController)
      })
      .disposed(by: self.disposeBag)
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
