//
//  SettingsViewModel.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

enum LogoutAlertActionItem {
  case logout
  case cancel
}

protocol SettingsViewModelType: class {
  // Input
  var tableViewDidSelectItem: PublishSubject<SettingsViewSectionItem> { get }
  var logoutAlertDidSelectActionItem: PublishSubject<LogoutAlertActionItem> { get }

  // Output
  var tableViewSections: Driver<[SettingsViewSection]> { get }
  var presentCarteViewController: Observable<Void> { get }
  var presentLogoutAlert: Observable<[LogoutAlertActionItem]> { get }
  var presentLoginScreen: Observable<LoginViewModelType> { get }
}

final class SettingsViewModel: SettingsViewModelType {

  // MARK: Input

  let tableViewDidSelectItem: PublishSubject<SettingsViewSectionItem> = .init()
  var logoutAlertDidSelectActionItem: PublishSubject<LogoutAlertActionItem> = .init()


  // MARK: Output

  let tableViewSections: Driver<[SettingsViewSection]>
  let presentCarteViewController: Observable<Void>
  let presentLogoutAlert: Observable<[LogoutAlertActionItem]>
  let presentLoginScreen: Observable<LoginViewModelType>


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

    self.presentCarteViewController = self.tableViewDidSelectItem
      .filter { sectionItem -> Bool in
        if case .openSource = sectionItem {
          return true
        } else {
          return false
        }
      }
      .mapVoid()

    self.presentLogoutAlert = self.tableViewDidSelectItem
      .filter { sectionItem -> Bool in
        if case .logout = sectionItem {
          return true
        } else {
          return false
        }
      }
      .map { _ in [.logout, .cancel] }

    self.presentLoginScreen = self.logoutAlertDidSelectActionItem
      .filter { $0 == .logout }
      .do(onNext: { _ in provider.authService.logout() })
      .map { _ in LoginViewModel(provider: provider) }
  }


  // MARK: Functions

  private class func aboutSection(
    provider: ServiceProviderType
  ) -> Observable<SettingsViewSection> {
    let sectionItems: [SettingsViewSectionItem] = [
      .version(SettingItemCellModel(text: "App Version".localized, detailText: "0.0.0")),
      .openSource(SettingItemCellModel(text: "Open Source License".localized, detailText: nil)),
    ]
    return .just(.about(sectionItems))
  }

  private class func logoutSection(
    provider: ServiceProviderType
  ) -> Observable<SettingsViewSection> {
    let logoutSectionItem: Observable<SettingsViewSectionItem> = provider.userService.currentUser
      .map { user -> SettingsViewSectionItem in
        .logout(SettingItemCellModel(text: "Logout".localized, detailText: user?.name))
      }
    return logoutSectionItem
      .map { sectionItem in [sectionItem] }
      .map { sectionItems in .logout(sectionItems) }
  }

}
