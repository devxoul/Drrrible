//
//  DI.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/05/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import Swinject
import SwinjectAutoregistration
import Then

extension Container: Then {}

let DI = Container().then {
  $0.register(Networking<DribbbleAPI>.self) { _ in Networking(plugins: [AuthPlugin()]) }.inObjectScope(.container)
  $0.autoregister(AuthServiceType.self, initializer: AuthService.init).inObjectScope(.container)
  $0.autoregister(UserServiceType.self, initializer: UserService.init).inObjectScope(.container)
  $0.autoregister(ShotServiceType.self, initializer: ShotService.init).inObjectScope(.container)
  $0.autoregister(AppStoreServiceType.self, initializer: AppStoreService.init).inObjectScope(.container)
}
