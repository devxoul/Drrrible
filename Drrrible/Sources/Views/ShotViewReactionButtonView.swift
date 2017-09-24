//
//  ShotViewReactionButtonView.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class ShotViewReactionButtonView: UIView, View {

  // MARK: Constants

  fileprivate struct Metric {
    static let buttonSize = 20.f
    static let labelLeft = 6.f
  }

  fileprivate struct Font {
    static let label = UIFont.systemFont(ofSize: 12)
  }


  // MARK: UI

  fileprivate let button = UIButton().then {
    $0.touchAreaInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  }
  fileprivate let label = UILabel().then {
    $0.font = Font.label
  }


  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: Initializing

  init(image: UIImage?, selectedImage: UIImage? = nil) {
    super.init(frame: .zero)
    self.button.setBackgroundImage(image, for: .normal)
    self.button.setBackgroundImage(selectedImage, for: .selected)
    self.addSubview(self.button)
    self.addSubview(self.label)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configure

  func bind(reactor: ShotViewReactionButtonViewReactor) {
    // Action
    self.button.rx.tap
      .map { Reactor.Action.toggleReaction }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State
    reactor.state.map { $0.isReacted }
      .filterNil()
      .distinctUntilChanged()
      .bind(to: self.button.rx.isSelected)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.canToggleReaction }
      .distinctUntilChanged()
      .bind(to: self.button.rx.isUserInteractionEnabled)
      .disposed(by: self.disposeBag)

    reactor.state.map { "\($0.count)" }
      .distinctUntilChanged()
      .bind(to: self.label.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.map { _ in }
      .bind(to: self.rx.setNeedsLayout)
      .disposed(by: self.disposeBag)
  }


  // MARK: Size

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    self.setNeedsLayout()
    self.layoutIfNeeded()
    return CGSize(width: self.label.right, height: self.button.height)
  }

  class func height() -> CGFloat {
    return Metric.buttonSize
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()

    self.button.width = Metric.buttonSize
    self.button.height = Metric.buttonSize

    self.label.sizeToFit()
    self.label.left = self.button.right + Metric.labelLeft
    self.label.centerY = self.button.centerY
  }

}
