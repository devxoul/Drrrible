//
//  ShotViewReactionCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit

final class ShotViewReactionCell: BaseCollectionViewCell, ViewType {

  // MARK: Constants

  fileprivate struct Metric {
    static let paddingTop = 5.f
    static let paddingLeftRight = 15.f
    static let paddingBottom = 10.f
    static let buttonViewSpacing = 10.f
  }


  // MARK: UI

  override class var layerClass: AnyClass {
    return BorderedLayer.self
  }

  fileprivate let likeButtonView = ShotViewReactionButtonView(
    image: UIImage(named: "icon-like"),
    selectedImage: UIImage(named: "icon-like-selected")
  )
  fileprivate let commentButtonView = ShotViewReactionButtonView(
    image: UIImage(named: "icon-comment")
  )


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.borderedLayer?.borders = .bottom
    self.contentView.addSubview(self.likeButtonView)
    self.contentView.addSubview(self.commentButtonView)
  }


  // MARK: Configure

  func configure(reactor: ShotViewReactionCellReactor) {
    self.likeButtonView.configure(reactor: reactor.likeButtonViewReactor)
    self.commentButtonView.configure(reactor: reactor.commentButtonViewReactor)
    self.setNeedsLayout()
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotViewReactionCellReactor) -> CGSize {
    let buttonViewHeight = ShotViewReactionButtonView.height()
    let height = Metric.paddingTop + buttonViewHeight + Metric.paddingBottom
    return CGSize(width: width, height: height)
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()

    self.likeButtonView.sizeToFit()
    self.likeButtonView.left = Metric.paddingLeftRight

    self.commentButtonView.sizeToFit()
    self.commentButtonView.left = self.likeButtonView.right + Metric.buttonViewSpacing
  }

}
