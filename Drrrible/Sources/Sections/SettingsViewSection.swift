//
//  SettingsViewSection.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxDataSources

enum SettingsViewSection {
  case about([SettingsViewSectionItem])
  case logout([SettingsViewSectionItem])
}

extension SettingsViewSection: SectionModelType {
  var items: [SettingsViewSectionItem] {
    switch self {
    case .about(let items): return items
    case .logout(let items): return items
    }
  }

  init(original: SettingsViewSection, items: [SettingsViewSectionItem]) {
    switch original {
    case .about: self = .about(items)
    case .logout: self = .logout(items)
    }
  }
}

enum SettingsViewSectionItem {
  case version(SettingItemCellReactor)
  case github(SettingItemCellReactor)
  case icons(SettingItemCellReactor)
  case openSource(SettingItemCellReactor)
  case logout(SettingItemCellReactor)
}
