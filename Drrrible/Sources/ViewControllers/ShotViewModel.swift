//
//  ShotViewModel.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ShotViewModelType {
  // Input
  var viewDidLoad: PublishSubject<Void> { get }

  // Output
  var collectionViewSections: Driver<[ShotViewSection]> { get }
}

final class ShotViewModel: ShotViewModelType {

  // MARK: Input

  let viewDidLoad: PublishSubject<Void> = .init()


  // MARK: Output

  let collectionViewSections: Driver<[ShotViewSection]>


  // MARK: Initializing

  init(provider: ServiceProviderType, shotID: Int, shot: Shot?) {
    let shotDidLoad: Observable<Shot> = self.viewDidLoad
      .flatMap { provider.shotService.shot(id: shotID) }
      .map { $0 as Shot? }
      .startWith(shot)
      .filterNil()
      .shareReplay(1)

    let shotSectionItemImage: Observable<ShotViewSectionItem> = shotDidLoad
      .map { shot in .image(ShotViewImageCellModel(provider: provider, shot: shot)) }
      .shareReplay(1)

    let shotSectionItemTitle: Observable<ShotViewSectionItem> = shotDidLoad
      .map { shot in .title(ShotViewTitleCellModel(provider: provider, shot: shot)) }
      .shareReplay(1)

    let shotSectionItemText: Observable<ShotViewSectionItem> = shotDidLoad
      .map { shot in .text(ShotViewTextCellModel(provider: provider, shot: shot)) }
      .shareReplay(1)

    let shotSectionItems = [shotSectionItemImage, shotSectionItemTitle, shotSectionItemText]
    let shotSection: Observable<ShotViewSection> = Observable<[ShotViewSectionItem]>
      .combineLatest(shotSectionItems) { $0 }
      .map { sectionItems in ShotViewSection.shot(sectionItems) }

    let sections = [shotSection]
    self.collectionViewSections = Observable<[ShotViewSection]>
      .combineLatest(sections) { $0 }
      .asDriver(onErrorJustReturn: [])
  }

}
