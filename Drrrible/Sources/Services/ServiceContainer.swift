//
//  ServiceContainer.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/05/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

/// A protocol that provides dependency injected service instances.
protocol ServiceContainer {}
extension ServiceContainer {
  var networking: Networking<DribbbleAPI> { return DI.resolve(Networking<DribbbleAPI>.self)! }
  var authService: AuthServiceType { return DI.resolve(AuthServiceType.self)! }
  var userService: UserServiceType { return DI.resolve(UserServiceType.self)! }
  var shotService: ShotServiceType { return DI.resolve(ShotServiceType.self)! }
  var appStoreService: AppStoreServiceType { return DI.resolve(AppStoreServiceType.self)! }
}
