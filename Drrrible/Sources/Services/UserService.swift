//
//  UserService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

protocol UserServiceType {
  var currentUser: Observable<User?> { get }

  func fetchMe() -> Observable<Void>
}

final class UserService: BaseService, UserServiceType {

  fileprivate let userSubject = ReplaySubject<User?>.create(bufferSize: 1)
  lazy var currentUser: Observable<User?> = self.userSubject.asObservable()
    .startWith(nil)
    .shareReplay(1)

  func fetchMe() -> Observable<Void> {
    return self.provider.networking.request(.me)
      .map(User.self)
      .do(onNext: { [weak self] user in
        self?.userSubject.onNext(user)
      })
      .map { _ in Void() }
  }

}
