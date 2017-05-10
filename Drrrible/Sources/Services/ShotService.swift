//
//  ShotService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

protocol ShotServiceType {
  func shots(paging: Paging) -> Observable<List<Shot>>
  func shot(id: Int) -> Observable<Shot>
  func isLiked(shotID: Int) -> Observable<Bool>
  func like(shotID: Int) -> Observable<Void>
  func unlike(shotID: Int) -> Observable<Void>
  func comments(shotID: Int) -> Observable<List<Comment>>
}

final class ShotService: ShotServiceType, ServiceContainer {

  func shots(paging: Paging) -> Observable<List<Shot>> {
    let api: DribbbleAPI
    switch paging {
    case .refresh: api = .shots
    case .next(let url): api = .url(url)
    }
    return self.networking.request(api).map(List<Shot>.self)
  }

  func shot(id: Int) -> Observable<Shot> {
    return self.networking.request(.shot(id: id)).map(Shot.self)
  }

  func isLiked(shotID: Int) -> Observable<Bool> {
    return self.networking.request(.isLikedShot(id: shotID))
      .map(true)
      .catchErrorJustReturn(false)
      .do(onNext: { isLiked in
        Shot.event.onNext(.updateLiked(id: shotID, isLiked: isLiked))
      })
  }

  func like(shotID: Int) -> Observable<Void> {
    Shot.event.onNext(.updateLiked(id: shotID, isLiked: true))
    Shot.event.onNext(.increaseLikeCount(id: shotID))
    return self.networking.request(.likeShot(id: shotID)).mapVoid()
      .do(onError: { error in
        Shot.event.onNext(.updateLiked(id: shotID, isLiked: false))
        Shot.event.onNext(.decreaseLikeCount(id: shotID))
      })
  }

  func unlike(shotID: Int) -> Observable<Void> {
    Shot.event.onNext(.updateLiked(id: shotID, isLiked: false))
    Shot.event.onNext(.decreaseLikeCount(id: shotID))
    return self.networking.request(.unlikeShot(id: shotID)).mapVoid()
      .do(onError: { error in
        Shot.event.onNext(.updateLiked(id: shotID, isLiked: true))
        Shot.event.onNext(.increaseLikeCount(id: shotID))
      })
  }

  func comments(shotID: Int) -> Observable<List<Comment>> {
    return self.networking.request(.shotComments(shotID: shotID)).map(List<Comment>.self)
  }

}
