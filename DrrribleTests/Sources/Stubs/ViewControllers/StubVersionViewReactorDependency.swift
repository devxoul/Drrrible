//
//  StubVersionViewReactorDependency.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 16/08/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

extension VersionViewReactor.Dependency {
  static func stub(
    appStoreService: AppStoreServiceType? = nil
  ) -> VersionViewReactor.Dependency {
    return .init(
      appStoreService: appStoreService ?? StubAppStoreService()
    )
  }
}
