//
//  SplashViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

// MARK: - Input

protocol SplashViewReactorInput {
  var viewDidAppear: PublishSubject<Void> { get }
}


// MARK: - Output

protocol SplashViewReactorOutput {
  var presentLoginScreen: Observable<LoginViewReactorType> { get }
  var presentMainScreen: Observable<MainTabBarViewReactorType> { get }
}


// MARK: - ViewReactor

typealias SplashViewReactorType = SplashViewReactorInput & SplashViewReactorOutput
final class SplashViewReactor: SplashViewReactorType {

  // MARK: Input

  let viewDidAppear: PublishSubject<Void> = .init()


  // MARK: Output

  let presentLoginScreen: Observable<LoginViewReactorType>
  let presentMainScreen: Observable<MainTabBarViewReactorType>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    let isAuthenticated = self.viewDidAppear
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
