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
    self.contentView.addSubview(self.avatarView)
    self.contentView.addSubview(self.titleLabel)
    self.contentView.addSubview(self.usernameLabel)
  }


  // MARK: Configuring

  func bind(reactor: ShotViewTitleCellReactor) {
    reactor.state.map { $0.avatarURL }
      .bind(to: self.avatarView.rx.resource)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.title }
      .distinctUntilChanged()
      .bind(to: self.titleLabel.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.username }
      .distinctUntilChanged()
      .bind(to: self.usernameLabel.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state
      .subscribe(onNext: { [weak self] _ in self?.setNeedsLayout() })
      .disposed(by: self.disposeBag)
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotViewTitleCellReactor) -> CGSize {
    let titleLabelWidth = width - Metric.avatarViewSize - Metric.titleLabelLeft
    let titleLabelHeight = reactor.currentState.title.height(
      thatFitsWidth: titleLabelWidth,
      font: Font.titleLabel
    )
    let usernameLabelHeight = snap(Font.usernameLabel.lineHeight)
    let contentHeight = max(
      Metric.avatarViewSize,
      Metric.titleLabelTop + titleLabelHeight + Metric.usernameLabelTop + usernameLabelHeight
    )
    return CGSize(width: width, height: contentHeight)
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()

    // Avatar
    self.avatarView.width = Metric.avatarViewSize
    self.avatarView.height = Metric.avatarViewSize

    // Title
    self.titleLabel.top = self.avatarView.top + Metric.titleLabelTop
    self.titleLabel.left = self.avatarView.right + Metric.titleLabelLeft
    self.titleLabel.width = self.contentView.width - self.titleLabel.left
    self.titleLabel.sizeToFit()

    // Username
    self.usernameLabel.sizeToFit()
    self.usernameLabel.top = self.titleLabel.bottom + Metric.usernameLabelTop
    self.usernameLabel.left = self.avatarView.right + Metric.usernameLabelLeft
    self.usernameLabel.width = min(
      self.usernameLabel.width,
      self.contentView.width - self.usernameLabel.left
    )
  }

}
