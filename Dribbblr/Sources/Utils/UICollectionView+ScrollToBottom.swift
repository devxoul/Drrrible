//
//  UICollectionView+ScrollToBottom.swift
//  Dribbble
//
//  Created by Suyeol Jeon on 16/02/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

extension UICollectionView {

  func isReachedBottom(withOffset offset: CGFloat = 0) -> Bool {
    guard self.contentSize.height > self.height, self.height > 0 else { return true }
    let contentOffsetBottom = self.contentOffset.y + self.height
    return contentOffsetBottom - offset >= self.contentSize.height
  }

  func scrollToBottom(animated: Bool) {
    guard self.contentSize.height > self.height, self.height > 0 else { return }
    let targetOffset = CGPoint(x: 0, y: self.contentSize.height + self.contentInset.bottom - self.height)
    self.setContentOffset(targetOffset, animated: true)
  }

}
