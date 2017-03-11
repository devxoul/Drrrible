//
//  SettingItemCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class SettingItemCell: BaseTableViewViewCell {

  // MARK: Initializing

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    self.accessoryType = .disclosureIndicator
  }


  // MARK: Configuring

  func configure(cellModel: SettingItemCellModelType) {
    self.textLabel?.text = cellModel.textLabelText
    self.detailTextLabel?.text = cellModel.detailTextLabelText
  }

}
