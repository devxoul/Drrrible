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

  // MARK: Types

  struct Dependency {
    let imageOptions: ImageOptions
    let navigator: NavigatorType
    let shotViewControllerFactory: (_ id: Int, _ shot: Shot?) -> ShotViewController
  }


  // MARK: Constants

  fileprivate struct Metric {
    static let imageViewMargin = 6.f
    static let gifLabelTop = 5.f
    static let gifLabelRight = 5.f
    static let gifLabelPaddingTopBottom = 2.f
    static let gifLabelPaddingLeftRight = 4.f
  }

  fileprivate struct Font {
    static let gifLabel = UIFont.systemFont(ofSize: 10)
  }


  // MARK: Properties

  var dependency: Dependency?


  // MARK: UI

  let cardView = UIImageView().then {
    $0.image = UIImage.resizable()
      .border(color: .db_border)
      .border(width: 1 / UIScreen.main.scale)
      .corner(radius: 2)
      .color(.white)
      .image
  }
  let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  let gifLabel = UILabel().then {
    $0.font = Font.gifLabel
    $0.text = "GIF"
    $0.textAlignment = .center
    $0.textColor = .white
    $0.layer.cornerRadius = 2
    $0.backgroundColor = UIColor.db_charcoal
    $0.alpha = 0.6
    $0.clipsToBounds = true
    $0.isUserInteractionEnabled = false
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.cardView)
    self.cardView.addSubview(self.imageView)
    self.imageView.addSubview(self.gifLabel)
  }


  // MARK: Configuring

  func bind(reactor: ShotCellReactor) {
    guard let dependency = self.dependency else { preconditionFailure() }

    // State
    reactor.state.map { $0.imageURL }
      .bind(to: self.imageView.rx.image(options: dependency.imageOptions))
      .disposed(by: self.disposeBag)

    reactor.state.map { !$0.isAnimatedImage }
      .bind(to: self.gifLabel.rx.isHidden)
      .disposed(by: self.disposeBag)

    // View
    self.cardView.rx.tapGesture()
      .filter { $0.state == .ended }
      .subscribe(onNext: { [weak reactor] _ in
        guard let reactor = reactor else { return }
        let viewController = dependency.shotViewControllerFactory(reactor.shot.id, reactor.shot)
        dependency.navigator.push(viewController)
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

    self.gifLabel.sizeToFit()
    self.gifLabel.width += Metric.gifLabelPaddingLeftRight * 2
    self.gifLabel.height += Metric.gifLabelPaddingTopBottom * 2
    self.gifLabel.top = Metric.gifLabelTop
    self.gifLabel.right = self.imageView.width - Metric.gifLabelRight
  }

}
