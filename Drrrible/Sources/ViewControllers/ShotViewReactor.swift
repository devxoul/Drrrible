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
  var dispose: PublishSubject<Void> { get }
  var refresh: PublishSubject<Void> { get }

  // Output
  var isRefreshing: Driver<Bool> { get }
  var sections: Driver<[ShotViewSection]> { get }
}

final class ShotViewReactor: ShotViewReactorType {

  // MARK: Types

  fileprivate enum CommentOperation {
    case refresh([Comment])
    case loadMore([Comment])
  }


  // MARK: Input

  let dispose: PublishSubject<Void> = .init()
  let refresh: PublishSubject<Void> = .init()


  // MARK: Output

  let isRefreshing: Driver<Bool>
  let sections: Driver<[ShotViewSection]>


  // MARK: Initializing

  init(provider: ServiceProviderType, shotID: Int, shot initialShot: Shot? = nil) {
    let shot: Observable<Shot> = Shot.event
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
      .filterNil()
      .shareReplay(1)

    let isRefreshing = ActivityIndicator()
    self.isRefreshing = isRefreshing.asDriver()

    let didRefreshShot = self.refresh
      .filter(!isRefreshing)
      .flatMap {
        provider.shotService.shot(id: shotID)
          .trackActivity(isRefreshing)
          .ignoreErrors()
      }
      .shareReplay(1)

    // Refresh shot
    _ = didRefreshShot
      .map(Shot.Event.update)
      .takeUntil(self.dispose)
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
      .takeUntil(self.dispose)
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

    //
    // Comment Section
    //
    let commentNextURL = Variable<URL?>(nil)
    let commentOperationRefresh = didRefreshShot
      .flatMap { shot in
        provider.shotService.comments(shotID: shotID)
          .catchErrorJustReturn(List(items: []))
      }
      .do(onNext: { commentList in
        commentNextURL.value = commentList.nextURL
      })
      .map { commentList in
        CommentOperation.refresh(commentList.items)
      }

    let commentOperation = commentOperationRefresh

    let comments: Observable<[Comment]> = commentOperation
      .scan([]) { comments, operation in
        switch operation {
        case let .refresh(newComments):
          return newComments

        case let .loadMore(newComments):
          return comments + newComments
        }
      }
      .startWith([])

    let commentSection: Observable<ShotViewSection> = comments
      .map { comments in
        let sectionItems: [ShotViewSectionItem] = comments.map { comment in
          let reactor = ShotViewCommentCellReactor(provider: provider, comment: comment)
          let sectionItem = ShotViewSectionItem.comment(reactor)
          return sectionItem
        }
        if sectionItems.isEmpty {
          return ShotViewSection.comment([.activityIndicator])
        } else {
          return ShotViewSection.comment(sectionItems)
        }
      }

    //
    // Section
    //
    let sections = [shotSection, commentSection]
    self.sections = Observable<[ShotViewSection]>
      .combineLatest(sections) { sections in
        guard !sections[0].items.isEmpty else { return [] }
        return sections
      }
      .asDriver(onErrorJustReturn: [])
  }

}
