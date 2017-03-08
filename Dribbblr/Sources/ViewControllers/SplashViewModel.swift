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
  var presentMainScreen: Observable<ShotsViewModelType> { get }
}


// MARK: - ViewModel

typealias SplashViewModelType = SplashViewModelInput & SplashViewModelOutput
final class SplashViewModel: SplashViewModelType {

  // MARK: Input

  let viewDidAppear: PublishSubject<Void> = .init()


  // MARK: Output

  let presentLoginScreen: Observable<LoginViewModelType>
  let presentMainScreen: Observable<ShotsViewModelType>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    self.presentLoginScreen = self.viewDidAppear
      .map { LoginViewModel(provider: provider) }
    self.presentMainScreen = .never()
  }

}
