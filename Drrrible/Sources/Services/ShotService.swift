//
//  ShotService.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

protocol ShotServiceType {
  func shots(paging: Paging) -> Observable<List<Shot>>
  func shot(id: Int) -> Observable<Shot>
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

}
