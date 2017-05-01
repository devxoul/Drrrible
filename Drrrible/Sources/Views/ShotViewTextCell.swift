//
//  ShotViewTextCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import TTTAttributedLabel

final class ShotViewTextCell: BaseCollectionViewCell, View {

  // MARK: Constants

  fileprivate struct Metric {
    static let paddingTop = 0.f
    static let paddingBottom = 10.f
    static let paddingLeftRight = 15.f
  }


  // MARK: UI

  fileprivate let label = TTTAttributedLabel(frame: .zero).then {
    $0.numberOfLines = 0
    $0.linkAttributes = [
      NSForegroundColorAttributeName: UIColor.db_linkBlue,
      NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue,
    ]
    $0.activeLinkAttributes = [
      NSForegroundColorAttributeName: UIColor.db_darkLinkBlue,
      NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue,
    ]
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.contentView.addSubview(self.label)
  }


  // MARK: Configuring

  func bind(reactor: ShotViewTextCellReactor) {
    reactor.state.map { $0.text }
      .subscribe(onNext: { [weak self] text in
        self?.label.setText(text)
      })
      .disposed(by: self.disposeBag)
    self.setNeedsLayout()
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotViewTextCellReactor) -> CGSize {
    guard let labelText = reactor.currentState.text else { return CGSize(width: width, height: 0) }
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
