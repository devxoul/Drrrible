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

  // MARK: UI

  fileprivate let label = TTTAttributedLabel(frame: .zero).then {
    $0.numberOfLines = 0
    $0.linkAttributes = [
      NSAttributedStringKey.foregroundColor: UIColor.db_linkBlue,
      NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleNone.rawValue,
    ]
    $0.activeLinkAttributes = [
      NSAttributedStringKey.foregroundColor: UIColor.db_darkLinkBlue,
      NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleNone.rawValue,
    ]
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.label)
  }


  // MARK: Configuring

  func bind(reactor: ShotViewTextCellReactor) {
    reactor.state.map { $0.text }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] text in
        self?.label.setText(text)
      })
      .disposed(by: self.disposeBag)
    self.setNeedsLayout()
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotViewTextCellReactor) -> CGSize {
    guard let labelText = reactor.currentState.text else { return CGSize(width: width, height: 0) }
    return CGSize(width: width, height: labelText.height(thatFitsWidth: width))
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    self.label.width = self.contentView.width
    self.label.sizeToFit()
  }
}
