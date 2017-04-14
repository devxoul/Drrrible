//
//  ShotViewTitleCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit

final class ShotViewTitleCell: BaseCollectionViewCell, View {

  // MARK: Types

  fileprivate struct Metric {
    static let paddingTopBottom = 10.f
    static let paddingLeftRight = 15.f

    static let avatarViewSize = 40.f

    static let titleLabelTop = 1.f
    static let titleLabelLeft = 10.f

    static let usernameLabelTop = 2.f
    static let usernameLabelLeft = 10.f
  }

  fileprivate struct Font {
    static let titleLabel = UIFont.boldSystemFont(ofSize: 15)
    static let usernameLabel = UIFont.systemFont(ofSize: 12)
  }

  fileprivate struct Color {
    static let titleLabelText = UIColor.black
    static let usernameLabelText = UIColor.db_slate
  }


  // MARK: UI

  fileprivate let avatarView = UIImageView().then {
    $0.layer.cornerRadius = Metric.avatarViewSize / 2
    $0.clipsToBounds = true
  }
  fileprivate let titleLabel = UILabel().then {
    $0.font = Font.titleLabel
    $0.textColor = Color.titleLabelText
    $0.numberOfLines = 0
  }
  fileprivate let usernameLabel = UILabel().then {
    $0.font = Font.usernameLabel
    $0.textColor = Color.usernameLabelText
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.contentView.addSubview(self.avatarView)
    self.contentView.addSubview(self.titleLabel)
    self.contentView.addSubview(self.usernameLabel)
  }


  // MARK: Configuring

  func configure(reactor: ShotViewTitleCellReactor) {
    reactor.state.map { $0.avatarURL }
      .subscribe(onNext: { [weak self] avatarURL in
        self?.avatarView.kf.setImage(with: avatarURL)
      })
      .addDisposableTo(self.disposeBag)

    reactor.state.map { $0.title }
      .bindTo(self.titleLabel.rx.text)
      .addDisposableTo(self.disposeBag)

    reactor.state.map { $0.username }
      .bindTo(self.usernameLabel.rx.text)
      .addDisposableTo(self.disposeBag)

    reactor.state
      .subscribe(onNext: { [weak self] _ in self?.setNeedsLayout() })
      .addDisposableTo(self.disposeBag)
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotViewTitleCellReactor) -> CGSize {
    let titleLabelWidth = width
      - Metric.paddingLeftRight
      - Metric.avatarViewSize
      - Metric.titleLabelLeft
      - Metric.paddingLeftRight
    let titleLabelHeight = reactor.currentState.title.height(
      thatFitsWidth: titleLabelWidth,
      font: Font.titleLabel
    )
    let usernameLabelHeight = snap(Font.usernameLabel.lineHeight)
    let contentHeight = max(
      Metric.avatarViewSize,
      Metric.titleLabelTop + titleLabelHeight + Metric.usernameLabelTop + usernameLabelHeight
    )
    return CGSize(width: width, height: Metric.paddingTopBottom * 2 + contentHeight)
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()

    // Avatar
    self.avatarView.top = Metric.paddingTopBottom
    self.avatarView.left = Metric.paddingLeftRight
    self.avatarView.width = Metric.avatarViewSize
    self.avatarView.height = Metric.avatarViewSize

    // Title
    self.titleLabel.top = self.avatarView.top + Metric.titleLabelTop
    self.titleLabel.left = self.avatarView.right + Metric.titleLabelLeft
    self.titleLabel.width = self.contentView.width - self.titleLabel.left - Metric.paddingLeftRight
    self.titleLabel.sizeToFit()

    // Username
    self.usernameLabel.sizeToFit()
    self.usernameLabel.top = self.titleLabel.bottom + Metric.usernameLabelTop
    self.usernameLabel.left = self.avatarView.right + Metric.usernameLabelLeft
    self.usernameLabel.width = min(
      self.usernameLabel.width,
      self.contentView.width - self.usernameLabel.left - Metric.paddingLeftRight
    )
  }

}
