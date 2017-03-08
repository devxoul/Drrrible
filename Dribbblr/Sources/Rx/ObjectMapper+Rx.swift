//
//  ObjectMapper+Rx.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Moya
import ObjectMapper
import RxSwift

extension ObservableType where E == Moya.Response {

  func map<T: ImmutableMappable>(_ mappableType: T.Type) -> Observable<T> {
    return self.mapString().map { jsonString -> T in
      return try Mapper<T>().map(JSONString: jsonString)
    }
  }

  func map<T: ImmutableMappable>(_ mappableType: [T].Type) -> Observable<[T]> {
    return self.mapString().map { jsonString -> [T] in
      return try Mapper<T>().mapArray(JSONString: jsonString)
    }
  }

}
