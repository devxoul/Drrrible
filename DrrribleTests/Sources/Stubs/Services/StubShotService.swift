//
//  StubShotService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
import Stubber
@testable import Drrrible

final class StubShotService: ShotServiceType {
  func shots(paging: Paging) -> Single<List<Shot>> {
    return Stubber.invoke(shots, args: paging, default: .never())
  }

  func shot(id: Int) -> Single<Shot> {
    return Stubber.invoke(shot, args: id, default: .never())
  }

  func isLiked(shotID: Int) -> Single<Bool> {
    return Stubber.invoke(isLiked, args: shotID, default: .never())
  }

  func like(shotID: Int) -> Single<Void> {
    return Stubber.invoke(like, args: shotID, default: .never())
  }

  func unlike(shotID: Int) -> Single<Void> {
    return Stubber.invoke(unlike, args: shotID, default: .never())
  }

  func comments(shotID: Int) -> Single<List<Comment>> {
    return Stubber.invoke(comments, args: shotID, default: .never())
  }
}
