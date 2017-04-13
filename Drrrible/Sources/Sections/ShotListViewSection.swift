//
//  ShotListViewSection.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxDataSources

enum ShotListViewSection {
  case shotTile([ShotListViewSectionItem])
}

extension ShotListViewSection: SectionModelType {
  var items: [ShotListViewSectionItem] {
    switch self {
    case .shotTile(let items): return items
    }
  }

  init(original: ShotListViewSection, items: [ShotListViewSectionItem]) {
    switch original {
    case .shotTile: self = .shotTile(items)
    }
  }
}

enum ShotListViewSectionItem {
  case shotTile(ShotCellReactor)
}
