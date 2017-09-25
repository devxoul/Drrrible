//
//  ModelType.swift
//  Dribbble
//
//  Created by Suyeol Jeon on 10/02/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Then

protocol ModelType: Codable, Then {
  associatedtype Event
}
