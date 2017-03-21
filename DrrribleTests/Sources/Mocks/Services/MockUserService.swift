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
    return .never()
  }

  var fetchMeClosure: () -> Observable<Void> = { return .never() }
  func fetchMe() -> Observable<Void> {
    return self.fetchMeClosure()
  }
}
