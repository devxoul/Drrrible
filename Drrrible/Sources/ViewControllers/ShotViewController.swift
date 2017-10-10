//
//  ShotViewController.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import ReusableKit
import RxCocoa
import RxDataSources
import UICollectionViewFlexLayout
import Umbrella
import URLNavigator

final class ShotViewController: BaseViewController, View {

  // MARK: Constants

  fileprivate struct Reusable {
    static let commentCell = ReusableCell<ShotViewCommentCell>()
    static let activityIndicatorCell = ReusableCell<CollectionActivityIndicatorCell>()
    static let sectionBackgroundView = ReusableView<CollectionBorderedBackgroundView>()
  }

  fileprivate struct Metric {
  }


  // MARK: Properties

  fileprivate let analytics: DrrribleAnalytics
  fileprivate let shotSectionDelegate: ShotSectionDelegate
  fileprivate let dataSource: RxCollectionViewSectionedReloadDataSource<ShotViewSection>


  // MARK: UI

  let refreshControl = UIRefreshControl().then {
    $0.layer.zPosition = -999
  }
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlexLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.alwaysBounceVertical = true
    $0.register(Reusable.commentCell)
    $0.register(Reusable.activityIndicatorCell)
    $0.register(Reusable.sectionBackgroundView, kind: UICollectionElementKindSectionBackground)
  }


  // MARK: Initializing

  init(
    reactor: ShotViewReactor,
    analytics: DrrribleAnalytics,
    shotSectionDelegateFactory: () -> ShotSectionDelegate
  ) {
    defer { self.reactor = reactor }
    self.analytics = analytics
    self.shotSectionDelegate = shotSectionDelegateFactory()
    self.dataSource = type(of: self).dataSourceFactory(shotSectionDelegate: self.shotSectionDelegate)
    super.init()
    self.title = "shot".localized
    self.shotSectionDelegate.registerReusables(to: self.collectionView)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private static func dataSourceFactory(
    shotSectionDelegate: ShotSectionDelegate
  ) -> RxCollectionViewSectionedReloadDataSource<ShotViewSection> {
    return .init(
      configureCell: { dataSource, collectionView, indexPath, sectionItem in
        switch sectionItem {
        case let .shot(item):
          return shotSectionDelegate.configureCell(collectionView, indexPath, item)

        case let .comment(cellReactor):
          let cell = collectionView.dequeue(Reusable.commentCell, for: indexPath)
          cell.reactor = cellReactor
          return cell

        case .activityIndicator:
          return collectionView.dequeue(Reusable.activityIndicatorCell, for: indexPath)
        }
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        switch dataSource[indexPath] {
        case let .shot(item):
          return shotSectionDelegate.background(
            collectionView: collectionView,
            kind: kind,
            indexPath: indexPath,
            sectionItem: item
          )

        case .comment:
          switch kind {
          case UICollectionElementKindSectionBackground:
            let view = collectionView.dequeue(Reusable.sectionBackgroundView, kind: kind, for: indexPath)
            view.backgroundColor = .white
            view.borderedLayer?.borders = [.bottom]
            return view

          default:
            return collectionView.emptyView(for: indexPath, kind: kind)
          }

        default:
          return collectionView.emptyView(for: indexPath, kind: kind)
        }
      }
    )
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .db_background
    self.view.addSubview(self.collectionView)
    self.collectionView.refreshControl = refreshControl
  }

  override func setupConstraints() {
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }


  // MARK: Configuring

  func bind(reactor: ShotViewReactor) {
    // Input
    self.rx.viewDidLoad
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.refreshControl.rx.controlEvent(.valueChanged)
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // Output
    reactor.state.map { $0.sections }
      .map { $0.isEmpty }
      .bind(to: self.collectionView.rx.isHidden)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.isRefreshing }
      .distinctUntilChanged()
      .bind(to: self.refreshControl.rx.isRefreshing)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.sections }
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    // View
    self.collectionView.rx.setDelegate(self)
      .disposed(by: self.disposeBag)

    // Analytics
    self.rx.viewDidAppear
      .subscribe(onNext: { [weak self] _ in
        self?.analytics.log(.viewShot(shotID: reactor.currentState.shotID))
      })
      .disposed(by: self.disposeBag)
  }
}


// MARK: - UICollectionViewDelegateFlexLayout

extension ShotViewController: UICollectionViewDelegateFlexLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    verticalSpacingBetweenSectionAt section: Int,
    and nextSection: Int
  ) -> CGFloat {
    return 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    paddingForSectionAt section: Int
  ) -> UIEdgeInsets {
    let section = self.dataSource[section]
    switch section {
    case .shot:
      return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)

    case .comment:
      return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    paddingForItemAt indexPath: IndexPath
  ) -> UIEdgeInsets {
    let sectionItem = self.dataSource[indexPath]
    switch sectionItem {
    case let .shot(item):
      return self.shotSectionDelegate.cellPadding(collectionViewLayout, indexPath, item)

    case .comment:
      return .zero

    case .activityIndicator:
      return .zero
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    verticalSpacingBetweenItemAt indexPath: IndexPath,
    and nextIndexPath: IndexPath
  ) -> CGFloat {
    switch (self.dataSource[indexPath], self.dataSource[nextIndexPath]) {
    case (_, .activityIndicator): return 0
    case let (.shot(item), .shot(nextItem)): return self.shotSectionDelegate.cellVerticalSpacing(item, nextItem)
    case (.shot, _): return 10
    case (.comment, .comment): return 15
    case (.comment, _): return 10
    case (.activityIndicator, _): return 0
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let maxWidth = collectionViewLayout.maximumWidth(forItemAt: indexPath)
    let sectionItem = self.dataSource[indexPath]
    switch sectionItem {
    case let .shot(item):
      return self.shotSectionDelegate.cellSize(collectionView, maxWidth, indexPath, item)

    case let .comment(cellReactor):
      return Reusable.commentCell.class.size(width: maxWidth, reactor: cellReactor)

    case .activityIndicator:
      return Reusable.activityIndicatorCell.class.size(width: maxWidth)
    }
  }
}
