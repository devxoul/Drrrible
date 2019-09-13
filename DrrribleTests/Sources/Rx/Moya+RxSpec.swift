//
//  Moya+RxSpec.swift
//  DrrribleTests
//
//  Created by Suyeol Jeon on 13/09/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

import Moya
import Nimble
import Quick
import RxSwift
@testable import Drrrible

final class Moya_RxSpec: QuickSpec {
  override func spec() {
    it("parses next url from Link header") {
      // given
      let disposeBag = DisposeBag()

      // when
      let url = URL(string: "https://example.com/page/2")!
      let headers = [
        "Link": "<https://example.com/page/1>; rel=\"prev\", <https://example.com/page/3>; rel=\"next\""
      ]
      let data = "[{}, {}, {}]".data(using: .utf8)!
      let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: headers)
      let moyaResponse = Moya.Response(statusCode: 200, data: data, request: nil, response: urlResponse)

      var receivedList: List<DummyMode>?
      Single.just(moyaResponse)
        .map(List<DummyMode>.self)
        .subscribe(onSuccess: { receivedList = $0 })
        .disposed(by: disposeBag)

      // then
      expect(receivedList?.nextURL?.absoluteString) == "https://example.com/page/3"
    }
  }
}

private struct DummyMode: ModelType {
  typealias Event = Never
}
