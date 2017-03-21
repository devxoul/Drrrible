//
//  SplashViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol SplashViewReactorType {
  // Input
  var checkIfAuthenticated: PublishSubject<Void> { get }

  // Output
  var presentLoginScreen: Observable<LoginViewReactorType> { get }
  var presentMainScreen: Observable<MainTabBarViewReactorType> { get }
}

final class SplashViewReactor: SplashViewReactorType {

  // MARK: Input

  let checkIfAuthenticated: PublishSubject<Void> = .init()


  // MARK: Output

  let presentLoginScreen: Observable<LoginViewReactorType>
  let presentMainScreen: Observable<MainTabBarViewReactorType>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    let isAuthenticated = self.checkIfAuthenticated
      .flatMap { provider.userService.fetchMe() }
      .map { true }
      .catchError { _ in .just(false) }
      .shareReplay(1)

    self.presentLoginScreen = isAuthenticated
      .filter { !$0 }
      .map { _ in LoginViewReactor(provider: provider) }

    self.presentMainScreen = isAuthenticated
      .filter { $0 }
      .map { _ in MainTabBarViewReactor(provider: provider) }
  }

}
