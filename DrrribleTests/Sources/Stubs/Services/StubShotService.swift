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
  func shots(paging: Paging) -> Observable<List<Shot>> {
    return Stubber.stubbed(shots, args: paging, default: .empty())
  }

  func shot(id: Int) -> Observable<Shot> {
    return Stubber.stubbed(shot, args: id, default: .empty())
  }

  func isLiked(shotID: Int) -> Observable<Bool> {
    return Stubber.stubbed(isLiked, args: shotID, default: .empty())
  }

  func like(shotID: Int) -> Observable<Void> {
    return Stubber.stubbed(like, args: shotID, default: .empty())
  }

  func unlike(shotID: Int) -> Observable<Void> {
    return Stubber.stubbed(unlike, args: shotID, default: .empty())
  }

  func comments(shotID: Int) -> Observable<List<Comment>> {
    return Stubber.stubbed(comments, args: shotID, default: .empty())
  }
}
