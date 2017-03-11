//
//  UICollectionView+CellWidth.swift
//  Dribbble
//
//  Created by Suyeol Jeon on 15/02/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

extension UICollectionView {

  func sectionWidth(at section: Int) -> CGFloat {
    var width = self.width
    width -= self.contentInset.left
    width -= self.contentInset.right

    if let delegate = self.delegate as? UICollectionViewDelegateFlowLayout,
      let inset = delegate.collectionView?(self, layout: self.collectionViewLayout, insetForSectionAt: section) {
      width -= inset.left
      width -= inset.right
    } else if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
      width -= layout.sectionInset.left
      width -= layout.sectionInset.right
    }

    return width
  }

}
