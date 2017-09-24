//
//  ShotViewCommentCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import TTTAttributedLabel

final class ShotViewCommentCell: BaseCollectionViewCell, View {

  // MARK: Constants

  fileprivate struct Metric {
    static let avatarViewSize = 30.f
    static let nameLabelLeft = 8.f

    static let messageLabelTop = 0.f
    static let messageLabelLeft = nameLabelLeft
  }

  fileprivate struct Font {
    static let nameLabel = UIFont.boldSystemFont(ofSize: 14)
  }


  // MARK: UI

  fileprivate let avatarView = UIImageView().then {
    $0.layer.cornerRadius = Metric.avatarViewSize / 2
    $0.clipsToBounds = true
  }
  fileprivate let nameLabel = UILabel().then {
    $0.font = Font.nameLabel
  }
  fileprivate let messageLabel = TTTAttributedLabel(frame: .zero).then {
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
    self.contentView.addSubview(self.avatarView)
    self.contentView.addSubview(self.nameLabel)
    self.contentView.addSubview(self.messageLabel)
  }


  // MARK: Configuring

  func bind(reactor: ShotViewCommentCellReactor) {
    reactor.state
      .subscribe(onNext: { [weak self] state in
        self?.avatarView.setImage(with: state.avatarURL)
        self?.nameLabel.text = state.name
        self?.messageLabel.setText(state.message)
        self?.setNeedsLayout()
      })
      .disposed(by: self.disposeBag)
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotViewCommentCellReactor) -> CGSize {
    var height: CGFloat = 0
    height += snap(Font.nameLabel.lineHeight)
    let messageLabelMaxWidth = width - Metric.avatarViewSize - Metric.messageLabelLeft
    height += Metric.messageLabelTop
    height += reactor.currentState.message.height(thatFitsWidth: messageLabelMaxWidth)
    return CGSize(width: width, height: height)
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()

    self.avatarView.width = Metric.avatarViewSize
    self.avatarView.height = Metric.avatarViewSize

    self.nameLabel.sizeToFit()
    self.nameLabel.left = self.avatarView.right + Metric.nameLabelLeft
    self.nameLabel.width = min(self.nameLabel.width, self.contentView.width - self.nameLabel.left)

    self.messageLabel.top = self.nameLabel.bottom + Metric.messageLabelTop
    self.messageLabel.left = self.avatarView.right + Metric.messageLabelLeft
    self.messageLabel.width = self.contentView.width - self.messageLabel.left
    self.messageLabel.sizeToFit()
  }
}
