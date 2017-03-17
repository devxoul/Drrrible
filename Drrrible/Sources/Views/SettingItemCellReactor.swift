//
//  SettingItemCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol SettingItemCellReactorType {
  var textLabelText: String? { get }
  var detailTextLabelText: String? { get }
}

final class SettingItemCellReactor: SettingItemCellReactorType {
  let textLabelText: String?
  let detailTextLabelText: String?

  init(text: String?, detailText: String?) {
    self.textLabelText = text
    self.detailTextLabelText = detailText
  }
}
