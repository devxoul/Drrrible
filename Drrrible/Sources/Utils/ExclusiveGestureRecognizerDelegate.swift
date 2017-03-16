//
//  ExclusiveGestureRecognizerDelegate.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxGesture
import RxSwift
import RxCocoa

final class ExclusiveGestureRecognizerDelegate: NSObject, GestureRecognizerDelegate {

  static let shared = ExclusiveGestureRecognizerDelegate()

  func gestureRecognizer(
    _ gestureRecognizer: GestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: GestureRecognizer
  ) -> Bool {
    return false
  }
}
