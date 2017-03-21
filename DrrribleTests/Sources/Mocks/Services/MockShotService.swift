//
//  MockShotService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
import Then

@testable import Drrrible

final class MockShotService: BaseService, ShotServiceType, Then {
  func shots(paging: Paging) -> Observable<List<Shot>> {
    return .never()
  }

  func shot(id: Int) -> Observable<Shot> {
    return .never()
  }

  func isLiked(shotID: Int) -> Observable<Bool> {
    return .never()
  }

  func like(shotID: Int) -> Observable<Void> {
    return .never()
  }

  func unlike(shotID: Int) -> Observable<Void> {
    return .never()
  }

  func comments(shotID: Int) -> Observable<List<Comment>> {
    return .never()
  }
}
