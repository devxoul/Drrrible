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
  }


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
    self.view.addSubview(self.collectionView)
    self.collectionView.addSubview(self.refreshControl)
  }

  override func setupConstraints() {
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }


  // MARK: Configuring

  private func configure(reactor: ShotViewReactorType) {
    self.collectionView.rx.setDelegate(self).addDisposableTo(self.disposeBag)
    self.dataSource.configureCell = { dataSource, collectionView, indexPath, sectionItem in
      switch sectionItem {
      case .image(let cellModel):
        let cell = collectionView.dequeue(Reusable.imageCell, for: indexPath)
        cell.configure(cellModel: cellModel)
        return cell

      case .title(let cellModel):
        let cell = collectionView.dequeue(Reusable.titleCell, for: indexPath)
        cell.configure(cellModel: cellModel)
        return cell

      case .text(let cellModel):
        let cell = collectionView.dequeue(Reusable.textCell, for: indexPath)
        cell.configure(cellModel: cellModel)
        return cell

      case .reaction(let cellModel):
        let cell = collectionView.dequeue(Reusable.reactionCell, for: indexPath)
        cell.configure(cellModel: cellModel)
        return cell
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
    case .image(let cellModel):
      return ShotViewImageCell.size(width: sectionWidth, cellModel: cellModel)

    case .title(let cellModel):
      return ShotViewTitleCell.size(width: sectionWidth, cellModel: cellModel)

    case .text(let cellModel):
      return ShotViewTextCell.size(width: sectionWidth, cellModel: cellModel)

    case .reaction(let cellModel):
      return ShotViewReactionCell.size(width: sectionWidth, cellModel: cellModel)
    }
  }

}
