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
    static let avatarViewSize = 18.f
    static let usernameLabelLeft = 6.f
    static let titleLabelTop = 6.f
  }

  fileprivate struct Font {
    static let usernameLabel = UIFont.systemFont(ofSize: 12)
    static let titleLabel = UIFont.boldSystemFont(ofSize: 15)
  }

  fileprivate struct Color {
    static let usernameLabelText = UIColor.db_slate
    static let titleLabelText = UIColor.black
  }

  struct Dependency {
    let imageOptions: ImageOptions
  }


  // MARK: Properties

  var dependency: Dependency?


  // MARK: UI

  fileprivate let avatarView = UIImageView().then {
    $0.layer.cornerRadius = Metric.avatarViewSize / 2
    $0.clipsToBounds = true
  }
  fileprivate let usernameLabel = UILabel().then {
    $0.font = Font.usernameLabel
    $0.textColor = Color.usernameLabelText
  }
  fileprivate let titleLabel = UILabel().then {
    $0.font = Font.titleLabel
    $0.textColor = Color.titleLabelText
    $0.numberOfLines = 0
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.avatarView)
    self.contentView.addSubview(self.usernameLabel)
    self.contentView.addSubview(self.titleLabel)
  }


  // MARK: Configuring

  func bind(reactor: ShotViewTitleCellReactor) {
    guard let dependency = self.dependency else { preconditionFailure() }

    reactor.state.map { $0.avatarURL }
      .bind(to: self.avatarView.rx.image(options: dependency.imageOptions))
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.username }
      .distinctUntilChanged()
      .bind(to: self.usernameLabel.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.title }
      .distinctUntilChanged()
      .bind(to: self.titleLabel.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.map { _ in }
      .bind(to: self.rx.setNeedsLayout)
      .disposed(by: self.disposeBag)
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotViewTitleCellReactor) -> CGSize {
    let titleLabelHeight = reactor.currentState.title.height(
      thatFitsWidth: width,
      font: Font.titleLabel
    )
    let contentHeight = Metric.avatarViewSize + Metric.titleLabelTop + titleLabelHeight
    return CGSize(width: width, height: contentHeight)
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()

    // Avatar
    self.avatarView.width = Metric.avatarViewSize
    self.avatarView.height = Metric.avatarViewSize

    // Username
    self.usernameLabel.sizeToFit()
    self.usernameLabel.centerY = self.avatarView.centerY
    self.usernameLabel.left = self.avatarView.right + Metric.usernameLabelLeft
    self.usernameLabel.width = min(
      self.usernameLabel.width,
      self.contentView.width - self.usernameLabel.left
    )

    // Title
    self.titleLabel.top = self.avatarView.bottom + Metric.titleLabelTop
    self.titleLabel.width = self.contentView.width - self.titleLabel.left
    self.titleLabel.sizeToFit()
  }

}
