//
//  Moya+Rx.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
  func map<T: ModelType>(_ type: T.Type) -> PrimitiveSequence<Trait, T> {
    return self.map(T.self, using: T.decoder)
  }

  func map<T: ModelType>(_ listType: List<T>.Type) -> PrimitiveSequence<Trait, List<T>> {
    return self
      .map { response -> List<T> in
        let items = try response.map([T].self, using: T.decoder)
        let nextURL = Self.findNextURL(response: response)
        return List<T>(items: items, nextURL: nextURL)
      }
      .do(onError: { error in
        if case let MoyaError.objectMapping(decodingError, _) = error {
          log.error(decodingError)
        }
      })
  }

  private static func findNextURL(response: Moya.Response) -> URL? {
    guard let linkString = response.response?.allHeaderFields["Link"] as? String else { return nil }
    return self.links(from: linkString)
      .first { url, relation in relation == "next" }
      .map { url, relation in url }
  }

  private static func links(from linkString: String) -> [(url: URL, relation: String)] {
    return linkString
      .components(separatedBy: ",")
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .compactMap { part in
        guard let urlString = self.firstMatch(in: part, pattern: "^<(.*)>") else { return nil }
        guard let url = URL(string: urlString) else { return nil }
        guard let relation = self.firstMatch(in: part, pattern: "rel=\"(.*)\"") else { return nil }
        return (url: url, relation: relation)
      }
  }

  private static func firstMatch(in string: String, pattern: String) -> String? {
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }

    let nsString = string as NSString
    let range = NSMakeRange(0, nsString.length)

    guard let result = regex.firstMatch(in: string, range: range) else { return nil }
    return nsString.substring(with: result.range(at: 1))
  }
}

// TODO: Temporary implementation

private extension HTTPURLResponse {
  func findLink(relation: String) -> Link? {
    return nil
  }
}

private struct Link {
  var uri: String
}
