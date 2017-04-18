//
//  ServiceProvider.swift
//  Dribbble
//
//  Created by Suyeol Jeon on 10/02/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

protocol ServiceProviderType: class {
  var networking: Networking<DribbbleAPI> { get }
  var authService: AuthServiceType { get }
  var userService: UserServiceType { get }
  var shotService: ShotServiceType { get }
  var appStoreService: AppStoreServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
  lazy var networking: Networking<DribbbleAPI> = .init(plugins: [AuthPlugin(provider: self)])
  lazy var authService: AuthServiceType = AuthService(provider: self)
  lazy var userService: UserServiceType = UserService(provider: self)
  lazy var shotService: ShotServiceType = ShotService(provider: self)
  lazy var appStoreService: AppStoreServiceType = AppStoreService(provider: self)
}
