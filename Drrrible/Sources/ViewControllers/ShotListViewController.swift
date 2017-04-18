//
//  ShotListViewController.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import ReusableKit
import RxDataSources

final class ShotListViewController: BaseViewController, View {

  // MARK: Constants

  fileprivate struct Reusable {
    static let shotTileCell = ReusableCell<ShotTileCell>()
    static let activityIndicatorView = ReusableView<CollectionActivityIndicatorView>()
    static let emptyView = ReusableView<UICollectionReusableView>()
  }

  fileprivate struct Constant {
    static let shotTileSectionColumnCount = 2
  }

  fileprivate struct Metric {
    static let shotTileSectionInsetLeftRight = 10.f
    static let shotTileSectionItemSpacing = 10.f
  }


  // MARK: Properties

  fileprivate let dataSource = RxCollectionViewSectionedReloadDataSource<ShotListViewSection>()


  // MARK: UI

  fileprivate let refreshControl = UIRefreshControl()
  fileprivate let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.register(Reusable.shotTileCell)
    $0.register(Reusable.activityIndicatorView, kind: UICollectionElementKindSectionFooter)
    $0.register(Reusable.emptyView, kind: "empty")
  }


  // MARK: Initializing

  init(reactor: ShotListViewReactor) {
    defer { self.reactor = reactor }
    super.init()
    self.title = "Shots"
    self.tabBarItem.image = UIImage(named: "tab-shots")
    self.tabBarItem.selectedImage = UIImage(named: "tab-shots-selected")
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .db_background
    self.view.addSubview(self.collectionView)
    self.collectionView.addSubview(self.refreshControl)
  }

  override func setupConstraints() {
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }


  // MARK: Configuring


  func bind(reactor: ShotListViewReactor) {
    self.collectionView.rx.setDelegate(self).addDisposableTo(self.disposeBag)

    self.dataSource.configureCell = { dataSource, collectionView, indexPath, sectionItem in
      switch sectionItem {
      case .shotTile(let reactor):
        let cell = collectionView.dequeue(Reusable.shotTileCell, for: indexPath)
        cell.reactor = reactor
        return cell
      }
    }
    self.dataSource.supplementaryViewFactory = { dataSource, collectionView, kind, indexPath in
      if kind == UICollectionElementKindSectionFooter {
        return collectionView.dequeue(Reusable.activityIndicatorView, kind: kind, for: indexPath)
      }
      return collectionView.dequeue(Reusable.emptyView, kind: "empty", for: indexPath)
    }

    // Action
    self.rx.viewDidLoad
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.refreshControl.rx.controlEvent(.valueChanged)
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.collectionView.rx.isReachedBottom
      .map { Reactor.Action.loadMore }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // Output
    reactor.state.map { $0.isRefreshing }
      .distinctUntilChanged()
      .bind(to: self.refreshControl.rx.isRefreshing)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.sections }
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }

}


// MARK: - UICollectionViewDelegateFlowLayout

extension ShotListViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    switch self.dataSource[section] {
    case .shotTile:
      let topBottom = Metric.shotTileSectionItemSpacing
      let leftRight = Metric.shotTileSectionInsetLeftRight
      return UIEdgeInsets(top: topBottom, left: leftRight, bottom: topBottom, right: leftRight)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch self.dataSource[section] {
    case .shotTile:
      return Metric.shotTileSectionItemSpacing
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch self.dataSource[section] {
    case .shotTile:
      return Metric.shotTileSectionItemSpacing
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let sectionWidth = collectionView.sectionWidth(at: indexPath.section)
    let sectionItem = self.dataSource[indexPath]
    switch sectionItem {
    case .shotTile(let reactor):
      let columnCount = Constant.shotTileSectionColumnCount.f
      let cellWidth = (sectionWidth - Metric.shotTileSectionItemSpacing) / columnCount
      return ShotTileCell.size(width: cellWidth, reactor: reactor)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    return CGSize(width: collectionView.width, height: 44)
  }

}
