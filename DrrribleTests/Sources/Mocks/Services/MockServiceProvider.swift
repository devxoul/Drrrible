//
//  MockServiceProvider.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

@testable import Drrrible

final class MockServiceProvider: ServiceProviderType {
  lazy var networking: Networking<DribbbleAPI> = .init()
  lazy var authService: AuthServiceType = MockAuthService(provider: self)
  lazy var userService: UserServiceType = MockUserService(provider: self)
  lazy var shotService: ShotServiceType = MockShotService(provider: self)
  lazy var appStoreService: AppStoreServiceType = MockAppStoreService(provider: self)
}
