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
    static let paddingTopBottom = 10.f
    static let paddingLeftRight = 15.f

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
    height += Metric.paddingTopBottom
    height += snap(Font.nameLabel.lineHeight)

    let messageLabelMaxWidth = width
      - Metric.paddingLeftRight * 2
      - Metric.avatarViewSize
      - Metric.messageLabelLeft
    height += Metric.messageLabelTop
    height += reactor.currentState.message.height(thatFitsWidth: messageLabelMaxWidth)
    height += Metric.paddingTopBottom
    return CGSize(width: width, height: height)
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()

    self.avatarView.top = Metric.paddingTopBottom
    self.avatarView.left = Metric.paddingLeftRight
    self.avatarView.width = Metric.avatarViewSize
    self.avatarView.height = Metric.avatarViewSize

    self.nameLabel.sizeToFit()
    self.nameLabel.top = Metric.paddingTopBottom
    self.nameLabel.left = self.avatarView.right + Metric.nameLabelLeft
    self.nameLabel.width = min(
      self.nameLabel.width,
      self.contentView.width - self.nameLabel.left - Metric.paddingLeftRight
    )

    self.messageLabel.top = self.nameLabel.bottom + Metric.messageLabelTop
    self.messageLabel.left = self.avatarView.right + Metric.messageLabelLeft
    self.messageLabel.width = self.contentView.width - self.messageLabel.left - Metric.paddingLeftRight
    self.messageLabel.sizeToFit()
  }

}
