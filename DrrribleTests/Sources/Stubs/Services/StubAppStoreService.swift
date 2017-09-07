//
//  StubAppStoreService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
import Stubber
@testable import Drrrible

final class StubAppStoreService: AppStoreServiceType {
  func latestVersion() -> Single<String?> {
    return Stubber.invoke(latestVersion, args: (), default: .never())
  }
}
