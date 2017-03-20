//
//  ShotViewCommentCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class ShotViewCommentCell: BaseCollectionViewCell {

  // MARK: Constants

  fileprivate struct Metric {
  }

  fileprivate struct Font {
    static let messageLabel = UIFont.systemFont(ofSize: 14)
  }


  // MARK: UI

  fileprivate let messageLabel = UILabel().then {
    $0.font = Font.messageLabel
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
  }


  // MARK: Configuring

  func configure(reactor: ShotViewCommentCellReactorType) {
    self.messageLabel.text = reactor.messageLabelText
    self.setNeedsLayout()
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotViewCommentCellReactorType) -> CGSize {
    return CGSize(width: width, height: 44)
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    self.messageLabel.sizeToFit()
  }

}
