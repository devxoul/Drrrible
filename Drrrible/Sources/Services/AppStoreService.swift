//
//  AppStoreService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

protocol AppStoreServiceType {
  func latestVersion() -> Single<String?>
}

final class AppStoreService: AppStoreServiceType {
  fileprivate let networking = Networking<AppStoreAPI>()

  func latestVersion() -> Single<String?> {
    guard let bundleID = Bundle.main.bundleIdentifier else { return .just(nil) }
    return self.networking.request(.lookup(bundleID: bundleID))
      .mapJSON()
      .flatMap { json -> Single<String?> in
        let version = (json as? [String: Any])
          .flatMap { $0["results"] as? [[String: Any]] }
          .flatMap { $0.first }
          .flatMap { $0["version"] as? String }
        return .just(version)
      }
  }
}
