//
//  ModelType.swift
//  Dribbble
//
//  Created by Suyeol Jeon on 10/02/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ObjectMapper
import Then

protocol ModelType: ImmutableMappable, Then {
  associatedtype Event
}
