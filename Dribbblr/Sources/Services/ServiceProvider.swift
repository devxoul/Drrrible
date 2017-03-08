//
//  ServiceProvider.swift
//  Dribbble
//
//  Created by Suyeol Jeon on 10/02/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

protocol ServiceProviderType: class {
  var authService: AuthServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
  lazy var authService: AuthServiceType = AuthService(provider: self)
}
