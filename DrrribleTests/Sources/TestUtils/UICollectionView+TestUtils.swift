//
//  UICollectionView+TestUtils.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 15/08/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

extension UICollectionView {
  func cell<Cell>(_ cellClass: Cell.Type, at section: Int, _ item: Int) -> Cell? {
    let indexPath = IndexPath(item: item, section: section)
    return self.dataSource?.collectionView(self, cellForItemAt: indexPath) as? Cell
  }
}
