//
//  UIGestureRecognizer+Test.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 24/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

extension UIGestureRecognizer {
  func sendAction(withState state: UIGestureRecognizerState? = nil) {
    if let state = state, self.state != state {
      self.setValue(state.rawValue, forKey: "state")
    }
    let gestureRecognizerTargets = self.value(forKey: "targets") as? [AnyObject] ?? []
    for gestureRecognizerTarget in gestureRecognizerTargets {
      let selector = NSSelectorFromString("_sendActionWithGestureRecognizer:")
      _ = gestureRecognizerTarget.perform(selector, with: self)
    }
  }
}
