//
//  StubUserService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
import Stubber
@testable import Drrrible

final class StubUserService: UserServiceType {
  var currentUser: Observable<User?> {
    return .never()
  }

  func fetchMe() -> Single<Void> {
    return Stubber.invoke(fetchMe, args: (), default: .never())
  }
}
