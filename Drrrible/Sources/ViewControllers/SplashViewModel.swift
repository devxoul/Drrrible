//
//  SplashViewModel.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

// MARK: - Input

protocol SplashViewModelInput {
  var viewDidAppear: PublishSubject<Void> { get }
}


// MARK: - Output

protocol SplashViewModelOutput {
  var presentLoginScreen: Observable<LoginViewModelType> { get }
  var presentMainScreen: Observable<MainTabBarViewModelType> { get }
}


// MARK: - ViewModel

typealias SplashViewModelType = SplashViewModelInput & SplashViewModelOutput
final class SplashViewModel: SplashViewModelType {

  // MARK: Input

  let viewDidAppear: PublishSubject<Void> = .init()


  // MARK: Output

  let presentLoginScreen: Observable<LoginViewModelType>
  let presentMainScreen: Observable<MainTabBarViewModelType>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    let isAuthenticated = self.viewDidAppear
      .flatMap { provider.userService.fetchMe() }
      .map { true }
      .catchError { _ in .just(false) }
      .shareReplay(1)

    self.presentLoginScreen = isAuthenticated
      .filter { !$0 }
      .map { _ in LoginViewModel(provider: provider) }

    self.presentMainScreen = isAuthenticated
      .filter { $0 }
      .map { _ in MainTabBarViewModel(provider: provider) }
  }

}
