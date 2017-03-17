//
//  ShotViewTextCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import TTTAttributedLabel

final class ShotViewTextCell: BaseCollectionViewCell {

  // MARK: Constants

  fileprivate struct Metric {
    static let paddingTop = 0.f
    static let paddingBottom = 10.f
    static let paddingLeftRight = 15.f
  }


  // MARK: UI

  fileprivate let label = TTTAttributedLabel(frame: .zero).then {
    $0.numberOfLines = 0
    $0.linkAttributes = [NSForegroundColorAttributeName: UIColor.db_linkBlue]
    $0.activeLinkAttributes = [NSForegroundColorAttributeName: UIColor.db_darkLinkBlue]
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.contentView.addSubview(self.label)
  }


  // MARK: Configuring

  func configure(reactor: ShotViewTextCellReactorType) {
    self.label.setText(reactor.labelText)
    self.setNeedsLayout()
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotViewTextCellReactorType) -> CGSize {
    guard let labelText = reactor.labelText else { return CGSize(width: width, height: 0) }
    let labelWidth = width - Metric.paddingLeftRight * 2
    let labelHeight = labelText.height(thatFitsWidth: labelWidth)
    return CGSize(width: width, height: labelHeight + Metric.paddingTop + Metric.paddingBottom)
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    self.label.top = Metric.paddingTop
    self.label.left = Metric.paddingLeftRight
    self.label.width = self.contentView.width - Metric.paddingLeftRight * 2
    self.label.sizeToFit()
  }

}
