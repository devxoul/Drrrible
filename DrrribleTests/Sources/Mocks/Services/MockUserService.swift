//
//  MockUserService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
import Then

@testable import Drrrible

final class MockUserService: BaseService, UserServiceType, Then {
  var currentUser: Observable<User?> {
    return .empty()
  }

  var fetchMeClosure: () -> Observable<Void> = { .just(Void()) }
  func fetchMe() -> Observable<Void> {
    return self.fetchMeClosure()
  }
}
