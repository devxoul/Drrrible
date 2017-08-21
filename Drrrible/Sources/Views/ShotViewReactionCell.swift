//
//  ShotViewReactionCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit

final class ShotViewReactionCell: BaseCollectionViewCell, View {

  // MARK: Constants

  fileprivate struct Metric {
    static let buttonViewSpacing = 10.f
  }


  // MARK: UI

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
    self.contentView.addSubview(self.likeButtonView)
    self.contentView.addSubview(self.commentButtonView)
  }


  // MARK: Configure

  func bind(reactor: ShotViewReactionCellReactor) {
    self.likeButtonView.reactor = reactor.likeButtonViewReactor
    self.commentButtonView.reactor = reactor.commentButtonViewReactor
    self.setNeedsLayout()
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotViewReactionCellReactor) -> CGSize {
    return CGSize(width: width, height: ShotViewReactionButtonView.height())
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    self.likeButtonView.sizeToFit()
    self.commentButtonView.sizeToFit()
    self.commentButtonView.left = self.likeButtonView.right + Metric.buttonViewSpacing
  }

}
