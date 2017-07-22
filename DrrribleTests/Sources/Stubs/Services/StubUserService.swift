//
//  StubUserService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
@testable import Drrrible

final class StubUserService: UserServiceType, Stub {
  var currentUser: Observable<User?> {
    return .empty()
  }

  func fetchMe() -> Observable<Void> {
    return self.call(fetchMe)
  }
}
