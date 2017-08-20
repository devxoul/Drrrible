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

final class SettingsViewReactor: Reactor {

  enum Action {
    case updateCurrentUsername(String?)
    case logout
  }

  enum Mutation {
    case updateLogoutSection(SettingsViewSection)
    case setLoggedOut
  }

  struct State {
    var sections: [SettingsViewSection] = []
    var isLoggedOut: Bool = false

    init(sections: [SettingsViewSection]) {
      self.sections = sections
    }
  }

  fileprivate let userService: UserServiceType
  let initialState: State

  init(userService: UserServiceType) {
    self.userService = userService
    let aboutSection = SettingsViewSection.about([
      .version(SettingItemCellReactor(
        text: "version".localized,
        detailText: Bundle.main.version
      )),
      .github(SettingItemCellReactor(text: "view_on_github".localized, detailText: "devxoul/Drrrible")),
      .icons(SettingItemCellReactor(text: "icons_from".localized, detailText: "icons8.com")),
      .openSource(SettingItemCellReactor(text: "open_source_license".localized, detailText: nil)),
    ])

    let logoutSection = SettingsViewSection.logout([
      .logout(SettingItemCellReactor(text: "logout".localized, detailText: nil))
    ])

    let sections = [aboutSection] + [logoutSection]
    self.initialState = State(sections: sections)
    _ = self.state
  }

  func transform(action: Observable<Action>) -> Observable<Action> {
    let updateCurrentUsername = self.userService.currentUser
      .map { Action.updateCurrentUsername($0?.name) }
    return Observable.of(action, updateCurrentUsername).merge()
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .updateCurrentUsername(name):
      let section = SettingsViewSection.logout([
        .logout(SettingItemCellReactor(text: "logout".localized, detailText: name))
      ])
      return .just(.updateLogoutSection(section))

    case .logout:
      return .just(.setLoggedOut)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
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

    case .setLoggedOut:
      state.isLoggedOut = true
      return state
    }
  }

}
