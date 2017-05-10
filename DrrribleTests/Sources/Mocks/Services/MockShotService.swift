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

final class MockShotService: ShotServiceType, ServiceContainer, Then {
  var shotsClosure: (_ paging: Paging) -> Observable<List<Shot>> = { _ in .empty() }
  func shots(paging: Paging) -> Observable<List<Shot>> {
    return self.shotsClosure(paging)
  }

  var shotClosure: (_ id: Int) -> Observable<Shot> = { _ in .empty() }
  func shot(id: Int) -> Observable<Shot> {
    return self.shotClosure(id)
  }

  var isLikedClosure: (_ shotID: Int) -> Observable<Bool> = { _ in .empty() }
  func isLiked(shotID: Int) -> Observable<Bool> {
    return self.isLikedClosure(shotID)
  }

  var likeClosure: (_ shotID: Int) -> Observable<Void> = { _ in .empty() }
  func like(shotID: Int) -> Observable<Void> {
    return self.likeClosure(shotID)
  }

  var unlikeClosure: (_ shotID: Int) -> Observable<Void> = { _ in .empty() }
  func unlike(shotID: Int) -> Observable<Void> {
    return self.unlikeClosure(shotID)
  }

  var commentsClosure: (_ shotID: Int) -> Observable<List<Comment>> = { _ in .empty() }
  func comments(shotID: Int) -> Observable<List<Comment>> {
    return self.commentsClosure(shotID)
  }
}
