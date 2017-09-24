//
//  ShotService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

protocol ShotServiceType {
  func shots(paging: Paging) -> Single<List<Shot>>
  func shot(id: Int) -> Single<Shot>
  func isLiked(shotID: Int) -> Single<Bool>
  func like(shotID: Int) -> Single<Void>
  func unlike(shotID: Int) -> Single<Void>
  func comments(shotID: Int) -> Single<List<Comment>>
}

final class ShotService: ShotServiceType {
  fileprivate let networking: DrrribleNetworking

  init(networking: DrrribleNetworking) {
    self.networking = networking
  }

  func shots(paging: Paging) -> Single<List<Shot>> {
    let api: DribbbleAPI
    switch paging {
    case .refresh: api = .shots
    case .next(let url): api = .url(url)
    }
    return self.networking.request(api).map(List<Shot>.self)
  }

  func shot(id: Int) -> Single<Shot> {
    return self.networking.request(.shot(id: id)).map(Shot.self)
  }

  func isLiked(shotID: Int) -> Single<Bool> {
    return self.networking.request(.isLikedShot(id: shotID))
      .map { _ in true }
      .catchError { _ in .just(false) }
      .do(onNext: { isLiked in
        Shot.event.onNext(.updateLiked(id: shotID, isLiked: isLiked))
      })
  }

  func like(shotID: Int) -> Single<Void> {
    Shot.event.onNext(.updateLiked(id: shotID, isLiked: true))
    Shot.event.onNext(.increaseLikeCount(id: shotID))
    return self.networking.request(.likeShot(id: shotID)).map { _ in }
      .do(onError: { error in
        Shot.event.onNext(.updateLiked(id: shotID, isLiked: false))
        Shot.event.onNext(.decreaseLikeCount(id: shotID))
      })
  }

  func unlike(shotID: Int) -> Single<Void> {
    Shot.event.onNext(.updateLiked(id: shotID, isLiked: false))
    Shot.event.onNext(.decreaseLikeCount(id: shotID))
    return self.networking.request(.unlikeShot(id: shotID)).map { _ in }
      .do(onError: { error in
        Shot.event.onNext(.updateLiked(id: shotID, isLiked: true))
        Shot.event.onNext(.increaseLikeCount(id: shotID))
      })
  }

  func comments(shotID: Int) -> Single<List<Comment>> {
    return self.networking.request(.shotComments(shotID: shotID)).map(List<Comment>.self)
  }
}
