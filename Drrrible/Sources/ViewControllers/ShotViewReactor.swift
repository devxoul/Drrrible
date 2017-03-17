//
//  ShotViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftUtilities

protocol ShotViewReactorType {
  // Input
  var viewDidLoad: PublishSubject<Void> { get }
  var viewDidDeallocate: PublishSubject<Void> { get }
  var refreshControlDidChangeValue: PublishSubject<Void> { get }

  // Output
  var refreshControlIsRefreshing: Driver<Bool> { get }
  var activityIndicatorViewIsAnimating: Driver<Bool> { get }
  var collectionViewIsHidden: Driver<Bool> { get }
  var collectionViewSections: Driver<[ShotViewSection]> { get }
}

final class ShotViewReactor: ShotViewReactorType {

  // MARK: Input

  let viewDidLoad: PublishSubject<Void> = .init()
  let viewDidDeallocate: PublishSubject<Void> = .init()
  let refreshControlDidChangeValue: PublishSubject<Void> = .init()


  // MARK: Output

  let refreshControlIsRefreshing: Driver<Bool>
  let activityIndicatorViewIsAnimating: Driver<Bool>
  let collectionViewIsHidden: Driver<Bool>
  let collectionViewSections: Driver<[ShotViewSection]>


  // MARK: Initializing

  init(provider: ServiceProviderType, shotID: Int, shot initialShot: Shot?) {
    let optionalShot: Observable<Shot?> = Shot.event
      .scan(initialShot) { oldShot, event in
        switch event {
        case let .create(newShot):
          guard newShot.id == shotID else { return oldShot }
          return newShot

        case let .update(newShot):
          guard newShot.id == shotID else { return oldShot }
          return newShot

        case let .delete(id):
          guard id == shotID else { return oldShot }
          return nil

        case let .like(id):
          guard id == shotID else { return oldShot }
          return oldShot?.with {
            $0.isLiked = true
            $0.likeCount += 1
          }

        case let .unlike(id):
          guard id == shotID else { return oldShot }
          return oldShot?.with {
            $0.isLiked = false
            $0.likeCount -= 1
          }
        }
      }
      .startWith(initialShot)
      .shareReplay(1)

    let shot = optionalShot
      .filterNil()
      .shareReplay(1)

    let isRefreshing = ActivityIndicator()
    self.refreshControlIsRefreshing = isRefreshing.asDriver()
    self.activityIndicatorViewIsAnimating = isRefreshing.asObservable()
      .withLatestFrom(optionalShot) { ($0, $1) }
      .map { isRefreshing, shot in
        return isRefreshing && shot == nil
      }
      .asDriver(onErrorJustReturn: false)
    self.collectionViewIsHidden = self.activityIndicatorViewIsAnimating

    let didRefreshShot = Observable
      .of(self.viewDidLoad.asObservable(), self.refreshControlDidChangeValue.asObservable())
      .merge()
      .flatMap {
        provider.shotService.shot(id: shotID)
          .trackActivity(isRefreshing)
          .ignoreErrors()
      }
      .shareReplay(1)

    // Refresh shot
    _ = didRefreshShot
      .map(Shot.Event.update)
      .takeUntil(self.viewDidDeallocate)
      .bindTo(Shot.event)

    // Refresh isLiked
    _ = didRefreshShot
      .flatMap { shot in
        provider.shotService.isLiked(shotID: shotID)
          .catchErrorJustReturn(false)
          .map { isLiked -> Shot in
            var newShot = shot
            newShot.isLiked = isLiked
            return newShot
          }
      }
      .map(Shot.Event.update)
      .takeUntil(self.viewDidDeallocate)
      .bindTo(Shot.event)

    let shotSectionItemImage: Observable<ShotViewSectionItem> = shot
      .map { shot in .image(ShotViewImageCellReactor(provider: provider, shot: shot)) }
      .shareReplay(1)

    let shotSectionItemTitle: Observable<ShotViewSectionItem> = shot
      .map { shot in .title(ShotViewTitleCellReactor(provider: provider, shot: shot)) }
      .shareReplay(1)

    let shotSectionItemText: Observable<ShotViewSectionItem> = shot
      .map { shot in .text(ShotViewTextCellReactor(provider: provider, shot: shot)) }
      .shareReplay(1)

    let shotSectionItemReaction: Observable<ShotViewSectionItem> = shot
      .map { shot in .reaction(ShotViewReactionCellReactor(provider: provider, shot: shot)) }
      .shareReplay(1)

    let shotSectionItems = [
      shotSectionItemImage,
      shotSectionItemTitle,
      shotSectionItemText,
      shotSectionItemReaction,
    ]
    let shotSection: Observable<ShotViewSection> = Observable<[ShotViewSectionItem]>
      .combineLatest(shotSectionItems) { $0 }
      .map { sectionItems in ShotViewSection.shot(sectionItems) }
      .shareReplay(1)

    let sections = [shotSection]
    self.collectionViewSections = Observable<[ShotViewSection]>
      .combineLatest(sections) { $0 }
      .asDriver(onErrorJustReturn: [])
  }

}
