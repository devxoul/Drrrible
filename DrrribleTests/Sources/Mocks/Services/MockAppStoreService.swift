//
//  MockAppStoreService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
@testable import Drrrible

final class MockAppStoreService: AppStoreServiceType, MockService {
  func latestVersion() -> Observable<String?> {
    return self.call(Self.latestVersion)
  }
}
