//
//  SettingsViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

struct SettingsViewComponents: ReactorComponents {
  enum Action {
    case selectItem(SettingsViewSectionItem)
    case updateCurrentUsername(String?)
    case logout
  }

  enum Mutation {
    case updateLogoutSection(SettingsViewSection)
    case setNavigation(Navigation)
  }

  struct State {
    var navigation: Navigation?
    var sections: [SettingsViewSection] = []

    init(sections: [SettingsViewSection]) {
      self.sections = sections
    }
  }

  enum Navigation {
    case webView(URL)
    case carteView
    case loginScreen(LoginViewReactor)
  }
}

final class SettingsViewReactor: Reactor<SettingsViewComponents> {

  fileprivate let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider

    let aboutSection = SettingsViewSection.about([
      .version(SettingItemCellReactor(
        text: "App Version".localized,
        detailText: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
      )),
      .icons(SettingItemCellReactor(text: "Icons from icons8.com".localized, detailText: nil)),
      .openSource(SettingItemCellReactor(text: "Open Source License".localized, detailText: nil)),
    ])

    let logoutSection = SettingsViewSection.logout([
      .logout(SettingItemCellReactor(text: "Logout".localized, detailText: nil))
    ])

    let sections = [aboutSection] + [logoutSection]
    let initialState = State(sections: sections)
    super.init(initialState: initialState)
  }

  override func transform(action: Observable<Action>) -> Observable<Action> {
    let updateCurrentUsername = self.provider.userService.currentUser
      .map { Action.updateCurrentUsername($0?.name) }
    return Observable.of(action, updateCurrentUsername).merge()
  }

  override func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .selectItem(sectionItem):
      switch sectionItem {
      case .icons:
        let url = URL(string: "https://icons8.com")!
        return .just(.setNavigation(.webView(url)))

      case .openSource:
        return .just(.setNavigation(.carteView))

      default:
        return .empty()
      }

    case let .updateCurrentUsername(name):
      let section = SettingsViewSection.logout([
        .logout(SettingItemCellReactor(text: "Logout".localized, detailText: name))
      ])
      return .just(.updateLogoutSection(section))

    case .logout:
      let reactor = LoginViewReactor(provider: self.provider)
      return .just(.setNavigation(.loginScreen(reactor)))
    }
  }

  override func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .updateLogoutSection(newSection):
      guard let index = state.sections.index(where: { section in
        if case (.logout, .logout) = (section, newSection) {
          return true
        } else {
          return false
        }
      })
      else { return state }
      state.sections[index] = newSection
      return state

    case let .setNavigation(navigation):
      state.navigation = navigation
      return state
    }
  }

}
