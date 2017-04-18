//
//  MockAppStoreService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
import Then

@testable import Drrrible

final class MockAppStoreService: BaseService, AppStoreServiceType, Then {
  var latestVersionClosure: () -> Observable<String?> = { .just(nil) }
  func latestVersion() -> Observable<String?> {
    return self.latestVersionClosure()
  }
}

