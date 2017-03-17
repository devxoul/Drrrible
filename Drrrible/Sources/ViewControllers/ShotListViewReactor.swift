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
  var viewDidLoad: PublishSubject<Void> { get }
  var viewDidDeallocate: PublishSubject<Void> { get }
  var refreshControlDidChangeValue: PublishSubject<Void> { get }
  var collectionViewDidReachBottom: PublishSubject<Void> { get }

  // Output
  var refreshControlIsRefreshing: Driver<Bool> { get }
  var collectionViewSections: Driver<[ShotListViewSection]> { get }
}

final class ShotListViewReactor: ShotListViewReactorType {

  // MARK: Types

  fileprivate enum ShotOperation {
    case refresh([Shot])
    case loadMore([Shot])
  }


  // MARK: Input

  let viewDidLoad: PublishSubject<Void> = .init()
  let viewDidDeallocate: PublishSubject<Void> = .init()
  let refreshControlDidChangeValue: PublishSubject<Void> = .init()
  let collectionViewDidReachBottom: PublishSubject<Void> = .init()


  // MARK: Output

  let refreshControlIsRefreshing: Driver<Bool>
  let collectionViewSections: Driver<[ShotListViewSection]>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    let isRefreshing = ActivityIndicator()
    let isLoading = ActivityIndicator()
    self.refreshControlIsRefreshing = isRefreshing.asDriver()

    let nextURL = Variable<URL?>(nil)

    let didRefreshShots = Observable
      .of(self.viewDidLoad, self.refreshControlDidChangeValue)
      .merge()
      .filter(!isRefreshing)
      .filter(!isLoading)
      .flatMap {
        provider.shotService.shots(paging: .refresh)
          .trackActivity(isRefreshing)
          .ignoreErrors()
      }
      .shareReplay(1)

    let didLoadMoreShots = self.collectionViewDidReachBottom
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
      .takeUntil(self.viewDidDeallocate)
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
      .shareReplay(1)

    let shotSection: Observable<[ShotListViewSection]> = shots
      .map { shots in
        let sectionItems = shots.map { shot -> ShotListViewSectionItem in
          let cellModel = ShotCellModel(provider: provider, shot: shot)
          return ShotListViewSectionItem.shotTile(cellModel)
        }
        let section = ShotListViewSection.shotTile(sectionItems)
        return [section]
      }
      .shareReplay(1)

    self.collectionViewSections = shotSection
      .asDriver(onErrorJustReturn: [])
  }

}
