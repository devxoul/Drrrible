//
//  SettingItemCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit

final class SettingItemCell: BaseTableViewCell, View {

  // MARK: Initializing

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    self.accessoryType = .disclosureIndicator
  }


  // MARK: Configuring

  func bind(reactor: SettingItemCellReactor) {
    reactor.state
      .subscribe(onNext: { [weak self] state in
        self?.textLabel?.text = state.text
        self?.detailTextLabel?.text = state.detailText
      })
      .disposed(by: self.disposeBag)
  }

}
