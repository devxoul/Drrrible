//
//  StubShotService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
@testable import Drrrible

final class StubShotService: ShotServiceType, Stub {
  func shots(paging: Paging) -> Observable<List<Shot>> {
    return self.call(shots, args: paging)
  }

  func shot(id: Int) -> Observable<Shot> {
    return self.call(shot, args: id)
  }

  func isLiked(shotID: Int) -> Observable<Bool> {
    return self.call(isLiked, args: shotID)
  }

  func like(shotID: Int) -> Observable<Void> {
    return self.call(like, args: shotID)
  }

  func unlike(shotID: Int) -> Observable<Void> {
    return self.call(unlike, args: shotID)
  }

  func comments(shotID: Int) -> Observable<List<Comment>> {
    return self.call(comments, args: shotID)
  }
}
