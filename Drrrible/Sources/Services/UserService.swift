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

  func fetchMe() -> Single<Void>
}

final class UserService: UserServiceType {
  fileprivate let networking: DrrribleNetworking

  init(networking: DrrribleNetworking) {
    self.networking = networking
  }

  fileprivate let userSubject = ReplaySubject<User?>.create(bufferSize: 1)
  lazy var currentUser: Observable<User?> = self.userSubject.asObservable()
    .startWith(nil)
    .share(replay: 1)

  func fetchMe() -> Single<Void> {
    return self.networking.request(.me)
      .map(User.self)
      .do(onNext: { [weak self] user in
        self?.userSubject.onNext(user)
      })
      .map { _ in }
  }
}
