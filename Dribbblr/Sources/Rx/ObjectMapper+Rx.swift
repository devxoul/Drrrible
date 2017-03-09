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
    return self.mapString()
      .map { jsonString -> T in
        return try Mapper<T>().map(JSONString: jsonString)
      }
      .do(onError: { error in
        if error is MapError {
          log.error(error)
        }
      })
  }

  func map<T: ImmutableMappable>(_ mappableType: [T].Type) -> Observable<[T]> {
    return self.mapString()
      .map { jsonString -> [T] in
        return try Mapper<T>().mapArray(JSONString: jsonString)
      }
      .do(onError: { error in
        if error is MapError {
          log.error(error)
        }
      })
  }

  func map<T: ImmutableMappable>(_ mappableType: List<T>.Type) -> Observable<List<T>> {
    return self
      .map { response in
        let jsonString = try response.mapString()
        let items = try Mapper<T>().mapArray(JSONString: jsonString)
        let nextURL = (response.response as? HTTPURLResponse)?
          .findLink(relation: "next")
          .flatMap { URL(string: $0.uri) }
        return List<T>(items: items, nextURL: nextURL)
      }
      .do(onError: { error in
        if error is MapError {
          log.error(error)
        }
      })
  }

}
