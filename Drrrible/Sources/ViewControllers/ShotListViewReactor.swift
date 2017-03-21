//
//  ShotListViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftUtilities

protocol ShotListViewReactorType {
  // Input
  var dispose: PublishSubject<Void> { get }
  var refresh: PublishSubject<Void> { get }
  var loadMore: PublishSubject<Void> { get }

  // Output
  var isRefreshing: Driver<Bool> { get }
  var sections: Driver<[ShotListViewSection]> { get }
}

final class ShotListViewReactor: ShotListViewReactorType {

  // MARK: Types

  fileprivate enum ShotOperation {
    case refresh([Shot])
    case loadMore([Shot])
  }


  // MARK: Input

  let dispose: PublishSubject<Void> = .init()
  let refresh: PublishSubject<Void> = .init()
  let loadMore: PublishSubject<Void> = .init()


  // MARK: Output

  let isRefreshing: Driver<Bool>
  let sections: Driver<[ShotListViewSection]>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    let isRefreshing = ActivityIndicator()
    let isLoading = ActivityIndicator()
    self.isRefreshing = isRefreshing.asDriver()

    let nextURL = Variable<URL?>(nil)

    let didRefreshShots = self.refresh
      .filter(!isRefreshing)
      .filter(!isLoading)
      .flatMap {
        provider.shotService.shots(paging: .refresh)
          .trackActivity(isRefreshing)
          .ignoreErrors()
      }
      .shareReplay(1)

    let didLoadMoreShots = self.loadMore
      .withLatestFrom(nextURL.asObservable())
      .filterNil()
      .filter(!isRefreshing)
      .filter(!isLoading)
      .flatMap { nextURL in
        provider.shotService.shots(paging: .next(nextURL))
          .trackActivity(isRefreshing)
          .ignoreErrors()
      }
      .shareReplay(1)

    _ = Observable.of(didRefreshShots, didLoadMoreShots).merge()
      .map { $0.nextURL }
      .takeUntil(self.dispose)
      .bindTo(nextURL)

    let shotOperationRefresh: Observable<ShotOperation> = didRefreshShots
      .map { list in ShotOperation.refresh(list.items) }
      .shareReplay(1)

    let shotOperationLoadMore: Observable<ShotOperation> = didLoadMoreShots
      .do(onNext: { [weak nextURL] list in
        nextURL?.value = list.nextURL
      })
      .map { list in ShotOperation.loadMore(list.items) }
      .shareReplay(1)

    let shots: Observable<[Shot]> = Observable
      .of(shotOperationRefresh, shotOperationLoadMore)
      .merge()
      .scan([]) { shots, operation in
        switch operation {
        case let .refresh(newShots):
          return newShots

        case let .loadMore(newShots):
          return shots + newShots
        }
      }
      .startWith([])
      .shareReplay(1)

    let shotSection: Observable<[ShotListViewSection]> = shots
      .map { shots in
        let sectionItems = shots.map { shot -> ShotListViewSectionItem in
          let reactor = ShotCellReactor(provider: provider, shot: shot)
          return ShotListViewSectionItem.shotTile(reactor)
        }
        let section = ShotListViewSection.shotTile(sectionItems)
        return [section]
      }
      .shareReplay(1)

    self.sections = shotSection
      .asDriver(onErrorJustReturn: [])
  }

}
