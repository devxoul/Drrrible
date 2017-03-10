//
//  SettingsViewModel.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol SettingsViewModelType {
  // Input
  var tableViewDidSelectItem: PublishSubject<IndexPath> { get }

  // Output
  var tableViewSections: Driver<[SettingsViewSection]> { get }
}

final class SettingsViewModel: SettingsViewModelType {

  // MARK: Input

  let tableViewDidSelectItem: PublishSubject<IndexPath> = .init()


  // MARK: Output

  let tableViewSections: Driver<[SettingsViewSection]>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    let cls = SettingsViewModel.self

    let sections = [
      cls.aboutSection(provider: provider),
      cls.logoutSection(provider: provider),
    ]
    self.tableViewSections = Observable
      .combineLatest(sections) { $0 }
      .asDriver(onErrorJustReturn: [])
  }


  // MARK: Functions

  private class func aboutSection(
    provider: ServiceProviderType
  ) -> Observable<SettingsViewSection> {
    let sectionItems: [SettingsViewSectionItem] = [
      .item(SettingItemCellModel(text: "App Version".localized, detailText: "0.0.0")),
      .item(SettingItemCellModel(text: "Open Source License".localized, detailText: nil)),
    ]
    return .just(.about(sectionItems))
  }

  private class func logoutSection(
    provider: ServiceProviderType
  ) -> Observable<SettingsViewSection> {
    let logoutSectionItem: Observable<SettingsViewSectionItem> = provider.userService.currentUser
      .map { user -> SettingsViewSectionItem in
        .item(SettingItemCellModel(text: "Logout".localized, detailText: user?.name))
      }
    return logoutSectionItem
      .map { sectionItem in [sectionItem] }
      .map { sectionItems in .logout(sectionItems) }
  }

}
