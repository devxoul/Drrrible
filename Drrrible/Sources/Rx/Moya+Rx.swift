//
//  Moya+Rx.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Moya
import RxSwift

extension PrimitiveSequence where TraitType == SingleTrait, Element == Moya.Response {
  func map<T: Decodable>(
    _ listType: List<T>.Type,
    dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
    dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
  ) -> PrimitiveSequence<TraitType, List<T>> {
    return self
      .map { response in
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        let items = try decoder.decode([T].self, from: response.data)
        let nextURL = response.response?
          .findLink(relation: "next")
          .flatMap { URL(string: $0.uri) }
        return List<T>(items: items, nextURL: nextURL)
      }
      .do(onError: { error in
        if error is DecodingError {
          log.error(error)
        }
      })
  }
}
