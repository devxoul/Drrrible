//
//  RefreshControl.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 04/12/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class RefreshControl: UIRefreshControl {
  private static let swizzle: Void = {
    method_exchangeImplementations(
      class_getInstanceMethod(RefreshControl.self, NSSelectorFromString("_scrollViewHeight"))!,
      class_getInstanceMethod(RefreshControl.self, NSSelectorFromString("ss_scrollViewHeight"))!
    )
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.zPosition = -999
  }

  override convenience init() {
    self.init(frame: .zero)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func didMoveToSuperview() {
    RefreshControl.swizzle
    super.didMoveToSuperview()
    if let scrollView = self.superview as? UIScrollView {
      self.tintColor = self.tintColor ?? UIRefreshControl.appearance().tintColor
      scrollView.contentOffset.y = -self.height
    }
  }

  @objc func ss_scrollViewHeight() -> CGFloat {
    // this makes refresh control distance shorter
    return 0
  }
}
