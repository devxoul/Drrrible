//
//  AnalyticsEvent.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/06/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Firebase
import Umbrella

typealias DrrribleAnalytics = Umbrella.Analytics<AnalyticsEvent>

enum AnalyticsEvent {
  case tryLogin
  case login
  case tryLogout
  case logout

  case viewShotList
  case viewShot(shotID: Int)

  case likeShot(shotID: Int)
  case unlikeShot(shotID: Int)

  case viewSettingList
}

extension AnalyticsEvent: EventType {
  func name(for provider: ProviderType) -> String? {
    switch self {
    case .tryLogin:
      return "try_login"

    case .login:
      switch provider {
      case is FirebaseProvider:
        return Firebase.AnalyticsEventLogin
      default:
        return "login"
      }

    case .tryLogout:
      return "try_logout"

    case .logout:
      return "logout"

    case .viewShotList:
      return "view_shot_list"

    case .viewShot:
      return "view_shot"

    case .likeShot:
      return "like_shot"

    case .unlikeShot:
      return "unlike_shot"

    case .viewSettingList:
      return "view_setting_list"
    }
  }

  func parameters(for provider: ProviderType) -> [String: Any]? {
    switch self {
    case .tryLogin:
      return nil

    case .login:
      return nil

    case .tryLogout:
      return nil

    case .logout:
      return nil

    case .viewShotList:
      return nil

    case let .viewShot(shotID):
      return [
        "shot_id": shotID
      ]

    case let .likeShot(shotID):
      return [
        "shot_id": shotID
      ]

    case let .unlikeShot(shotID):
      return [
        "shot_id": shotID
      ]

    case .viewSettingList:
      return nil
    }
  }
}
