//
//  LoginViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftUtilities

protocol LoginViewReactorType {
  // Input
  var login: PublishSubject<Void> { get }

  // Output
  var isLoading: Driver<Bool> { get }
  var presentMainScreen: Observable<MainTabBarViewReactorType> { get }
}

final class LoginViewReactor: LoginViewReactorType {

  // MARK: Input

  let login: PublishSubject<Void> = .init()


  // MARK: Output

  let isLoading: Driver<Bool>
  let presentMainScreen: Observable<MainTabBarViewReactorType>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    let isLoading = ActivityIndicator()
    self.isLoading = isLoading.asDriver()
    self.presentMainScreen = self.login
      .filter(!isLoading)
      .flatMap { provider.authService.authorize().trackActivity(isLoading) }
      .flatMap { provider.userService.fetchMe() }
      .map { MainTabBarViewReactor(provider: provider) }
  }

}
