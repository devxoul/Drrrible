//
//  LoginViewModel.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftUtilities

// MARK: - Input

protocol LoginViewModelInput {
  var loginButtonDidTap: PublishSubject<Void> { get }
}


// MARK: - Output

protocol LoginViewModelOutput {
  var loginButtonEnabled: Driver<Bool> { get }
  var presentMainScreen: Observable<ShotListViewModelType> { get }
}


// MARK: - ViewModel

typealias LoginViewModelType = LoginViewModelInput & LoginViewModelOutput
final class LoginViewModel: LoginViewModelType {

  // MARK: Input

  let loginButtonDidTap: PublishSubject<Void> = .init()


  // MARK: Output

  let loginButtonEnabled: Driver<Bool>
  let presentMainScreen: Observable<ShotListViewModelType>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    let isLoading = ActivityIndicator()

    self.loginButtonEnabled = isLoading.map { !$0 }.asDriver()
    self.presentMainScreen = self.loginButtonDidTap
      .flatMap { provider.authService.authorize().trackActivity(isLoading) }
      .flatMap { provider.userService.fetchMe() }
      .map { ShotListViewModel(provider: provider) }
  }

}
