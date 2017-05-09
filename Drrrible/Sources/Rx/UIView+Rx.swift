//
//  UIView+Rx.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/05/2017.
//  Copyright © 2017 StyleShare Inc. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIView {
  var setNeedsLayout: UIBindingObserver<Base, Void> {
    return UIBindingObserver(UIElement: self.base) { view, _ in
      view.setNeedsLayout()
    }
  }
}
