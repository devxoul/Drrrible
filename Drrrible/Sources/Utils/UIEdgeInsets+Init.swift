//
//  UIEdgeInsets+Init.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

  init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }

  init(topBottom: CGFloat = 0, leftRight: CGFloat = 0) {
    self.top = topBottom
    self.left = leftRight
    self.bottom = topBottom
    self.right = leftRight
  }

}
