//
//  ShotViewController.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReusableKit
import RxDataSources

final class ShotViewController: BaseViewController {

  // MARK: Constants

  fileprivate struct Reusable {
    static let imageCell = ReusableCell<ShotViewImageCell>()
    static let titleCell = ReusableCell<ShotViewTitleCell>()
    static let textCell = ReusableCell<ShotViewTextCell>()
    static let reactionCell = ReusableCell<ShotViewReactionCell>()
    static let commentCell = ReusableCell<ShotViewCommentCell>()
    static let activityIndicatorCell = ReusableCell<CollectionActivityIndicatorCell>()
  }

  fileprivate struct Metric {
  }


  // MARK: Properties

  fileprivate let dataSource = RxCollectionViewSectionedReloadDataSource<ShotViewSection>()


  // MARK: UI

  fileprivate let refreshControl = UIRefreshControl()
  fileprivate let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.alwaysBounceVertical = true
    $0.register(Reusable.imageCell)
    $0.register(Reusable.titleCell)
    $0.register(Reusable.textCell)
    $0.register(Reusable.reactionCell)
    $0.register(Reusable.commentCell)
    $0.register(Reusable.activityIndicatorCell)
  }
  fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)


  // MARK: Initializing

  init(reactor: ShotViewReactorType) {
    super.init()
    self.title = "Shot"
    self.configure(reactor: reactor)
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
    self.view.addSubview(self.activityIndicatorView)
  }

  override func setupConstraints() {
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    self.activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }


  // MARK: Configuring

  private func configure(reactor: ShotViewReactorType) {
    self.collectionView.rx.setDelegate(self).addDisposableTo(self.disposeBag)
    self.dataSource.configureCell = { dataSource, collectionView, indexPath, sectionItem in
      switch sectionItem {
      case .image(let reactor):
        let cell = collectionView.dequeue(Reusable.imageCell, for: indexPath)
        cell.configure(reactor: reactor)
        return cell

      case .title(let reactor):
        let cell = collectionView.dequeue(Reusable.titleCell, for: indexPath)
        cell.configure(reactor: reactor)
        return cell

      case .text(let reactor):
        let cell = collectionView.dequeue(Reusable.textCell, for: indexPath)
        cell.configure(reactor: reactor)
        return cell

      case .reaction(let reactor):
        let cell = collectionView.dequeue(Reusable.reactionCell, for: indexPath)
        cell.configure(reactor: reactor)
        return cell

      case .comment(let reactor):
        let cell = collectionView.dequeue(Reusable.commentCell, for: indexPath)
        cell.configure(reactor: reactor)
        return cell

      case .activityIndicator:
        return collectionView.dequeue(Reusable.activityIndicatorCell, for: indexPath)
      }
    }

    // Input
    self.rx.viewDidLoad
      .bindTo(reactor.viewDidLoad)
      .addDisposableTo(self.disposeBag)

    self.rx.deallocated
      .bindTo(reactor.viewDidDeallocate)
      .addDisposableTo(self.disposeBag)

    self.refreshControl.rx.controlEvent(.valueChanged)
      .bindTo(reactor.refreshControlDidChangeValue)
      .addDisposableTo(self.disposeBag)

    // Output
    reactor.refreshControlIsRefreshing
      .drive(self.refreshControl.rx.isRefreshing)
      .addDisposableTo(self.disposeBag)

    reactor.activityIndicatorViewIsAnimating
      .drive(self.activityIndicatorView.rx.isAnimating)
      .addDisposableTo(self.disposeBag)

    reactor.collectionViewIsHidden
      .drive(self.collectionView.rx.isHidden)
      .addDisposableTo(self.disposeBag)

    reactor.collectionViewSections
      .drive(self.collectionView.rx.items(dataSource: self.dataSource))
      .addDisposableTo(self.disposeBag)
  }

}


// MARK: - UICollectionViewDelegateFlowLayout

extension ShotViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let sectionWidth = collectionView.sectionWidth(at: indexPath.section)
    let sectionItem = self.dataSource[indexPath]
    switch sectionItem {
    case .image(let reactor):
      return ShotViewImageCell.size(width: sectionWidth, reactor: reactor)

    case .title(let reactor):
      return ShotViewTitleCell.size(width: sectionWidth, reactor: reactor)

    case .text(let reactor):
      return ShotViewTextCell.size(width: sectionWidth, reactor: reactor)

    case .reaction(let reactor):
      return ShotViewReactionCell.size(width: sectionWidth, reactor: reactor)

    case .comment(let reactor):
      return ShotViewCommentCell.size(width: sectionWidth, reactor: reactor)

    case .activityIndicator:
      return CollectionActivityIndicatorCell.size(width: sectionWidth)
    }
  }

}
