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

final class ShotService: BaseService, ShotServiceType {

  func shots(paging: Paging) -> Observable<List<Shot>> {
    let api: DribbbleAPI
    switch paging {
    case .refresh: api = .shots
    case .next(let url): api = .url(url)
    }
    return self.provider.networking.request(api).map(List<Shot>.self)
  }

  func shot(id: Int) -> Observable<Shot> {
    return self.provider.networking.request(.shot(id: id)).map(Shot.self)
  }

  func isLiked(shotID: Int) -> Observable<Bool> {
    return self.provider.networking.request(.isLikedShot(id: shotID)).map(true)
  }

  func like(shotID: Int) -> Observable<Void> {
    return self.provider.networking.request(.likeShot(id: shotID)).mapVoid()
  }

  func unlike(shotID: Int) -> Observable<Void> {
    return self.provider.networking.request(.likeShot(id: shotID)).mapVoid()
  }

  func comments(shotID: Int) -> Observable<List<Comment>> {
    return self.provider.networking.request(.shotComments(shotID: shotID)).map(List<Comment>.self)
  }

}
