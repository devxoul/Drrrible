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
    static let imageCell = ReusableCell<ShotViewImageCell>()
    static let titleCell = ReusableCell<ShotViewTitleCell>()
    static let textCell = ReusableCell<ShotViewTextCell>()
    static let reactionCell = ReusableCell<ShotViewReactionCell>()
    static let commentCell = ReusableCell<ShotViewCommentCell>()
    static let activityIndicatorCell = ReusableCell<CollectionActivityIndicatorCell>()
    static let sectionBackgroundView = ReusableView<CollectionBorderedBackgroundView>()
    static let itemBackgroundView = ReusableView<CollectionBorderedBackgroundView>()
  }

  fileprivate struct Metric {
  }


  // MARK: Properties

  fileprivate let analytics: DrrribleAnalytics
  fileprivate let dataSource = RxCollectionViewSectionedReloadDataSource<ShotViewSection>()


  // MARK: UI

  let refreshControl = UIRefreshControl()
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlexLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.alwaysBounceVertical = true
    $0.register(Reusable.imageCell)
    $0.register(Reusable.titleCell)
    $0.register(Reusable.textCell)
    $0.register(Reusable.reactionCell)
    $0.register(Reusable.commentCell)
    $0.register(Reusable.activityIndicatorCell)
    $0.register(Reusable.sectionBackgroundView, kind: UICollectionElementKindSectionBackground)
    $0.register(Reusable.itemBackgroundView, kind: UICollectionElementKindItemBackground)
  }


  // MARK: Initializing

  init(reactor: ShotViewReactor, analytics: DrrribleAnalytics) {
    defer { self.reactor = reactor }
    self.analytics = analytics
    super.init()
    self.title = "shot".localized

    self.dataSource.configureCell = { dataSource, collectionView, indexPath, sectionItem in
      switch sectionItem {
      case let .image(cellReactor):
        let cell = collectionView.dequeue(Reusable.imageCell, for: indexPath)
        cell.reactor = cellReactor
        return cell

      case let .title(cellReactor):
        let cell = collectionView.dequeue(Reusable.titleCell, for: indexPath)
        cell.reactor = cellReactor
        return cell

      case let .text(cellReactor):
        let cell = collectionView.dequeue(Reusable.textCell, for: indexPath)
        cell.reactor = cellReactor
        return cell

      case let .reaction(cellReactor):
        let cell = collectionView.dequeue(Reusable.reactionCell, for: indexPath)
        cell.reactor = cellReactor
        return cell

      case let .comment(cellReactor):
        let cell = collectionView.dequeue(Reusable.commentCell, for: indexPath)
        cell.reactor = cellReactor
        return cell

      case .activityIndicator:
        return collectionView.dequeue(Reusable.activityIndicatorCell, for: indexPath)
      }
    }

    self.dataSource.supplementaryViewFactory = { dataSource, collectionView, kind, indexPath in
      switch kind {
      case UICollectionElementKindSectionBackground:
        let view = collectionView.dequeue(Reusable.sectionBackgroundView, kind: kind, for: indexPath)
        view.backgroundColor = .white
        switch dataSource[indexPath.section] {
        case .shot:
          view.borderedLayer?.borders = [.top, .bottom]
        case .comment:
          view.borderedLayer?.borders = [.bottom]
        }
        return view

      case UICollectionElementKindItemBackground:
        let view = collectionView.dequeue(Reusable.itemBackgroundView, kind: kind, for: indexPath)
        view.isHidden = true
        return view

      default:
        fatalError()
      }
    }
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .db_background

    self.collectionView.addSubview(self.refreshControl)
    self.view.addSubview(self.collectionView)
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
    self.collectionView.rx.setDelegate(self).addDisposableTo(self.disposeBag)

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
    case .image:
      let sectionPadding = self.collectionView(
        collectionView,
        layout: collectionViewLayout,
        paddingForSectionAt: indexPath.section
      )
      return UIEdgeInsets(
        top: 0,
        left: -sectionPadding.left,
        bottom: 0,
        right: -sectionPadding.right
      )

    case .title:
      return .zero

    case .text:
      return .zero

    case .reaction:
      return .zero

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
    case (.image, _): return 10
    case (.title, _): return 10
    case (.text, _): return 10
    case (.reaction, _): return 10
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
    case let .image(cellReactor):
      return Reusable.imageCell.class.size(width: maxWidth, reactor: cellReactor)

    case let .title(cellReactor):
      return Reusable.titleCell.class.size(width: maxWidth, reactor: cellReactor)

    case let .text(cellReactor):
      return Reusable.textCell.class.size(width: maxWidth, reactor: cellReactor)

    case let .reaction(cellReactor):
      return Reusable.reactionCell.class.size(width: maxWidth, reactor: cellReactor)

    case let .comment(cellReactor):
      return Reusable.commentCell.class.size(width: maxWidth, reactor: cellReactor)

    case .activityIndicator:
      return Reusable.activityIndicatorCell.class.size(width: maxWidth)
    }
  }
}
