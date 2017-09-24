//
//  UICollectionView+Rx.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 11/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift

extension Reactive where Base: UICollectionView {
  func itemSelected<S>(dataSource: CollectionViewSectionedDataSource<S>) -> ControlEvent<S.Item> {
    let source = self.itemSelected.map { indexPath in
      dataSource[indexPath]
    }
    return ControlEvent(events: source)
  }
}
