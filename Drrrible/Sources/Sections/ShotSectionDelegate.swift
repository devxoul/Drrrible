//
//  ShotSectionDelegate.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReusableKit
import SectionReactor
import UICollectionViewFlexLayout

final class ShotSectionDelegate: SectionDelegateType {
  private struct Reusable {
    static let imageCell = ReusableCell<ShotViewImageCell>()
    static let titleCell = ReusableCell<ShotViewTitleCell>()
    static let textCell = ReusableCell<ShotViewTextCell>()
    static let reactionCell = ReusableCell<ShotViewReactionCell>()
    static let sectionBackgroundView = ReusableView<CollectionBorderedBackgroundView>()
  }

  typealias SectionReactor = ShotSectionReactor

  private let imageCellDependency: ShotViewImageCell.Dependency
  private let titleCellDependency: ShotViewTitleCell.Dependency

  init(
    imageCellDependency: ShotViewImageCell.Dependency,
    titleCellDependency: ShotViewTitleCell.Dependency
  ) {
    self.imageCellDependency = imageCellDependency
    self.titleCellDependency = titleCellDependency
  }

  func registerReusables(to collectionView: UICollectionView) {
    collectionView.register(Reusable.imageCell)
    collectionView.register(Reusable.titleCell)
    collectionView.register(Reusable.textCell)
    collectionView.register(Reusable.reactionCell)
    collectionView.register(Reusable.sectionBackgroundView, kind: UICollectionElementKindSectionBackground)
  }

  func configureCell(
    _ collectionView: UICollectionView,
    _ indexPath: IndexPath,
    _ sectionItem: SectionItem
  ) -> UICollectionViewCell {
    switch sectionItem {
    case let .image(cellReactor):
      let cell = collectionView.dequeue(Reusable.imageCell, for: indexPath)
      cell.dependency = self.imageCellDependency
      cell.reactor = cellReactor
      return cell

    case let .title(cellReactor):
      let cell = collectionView.dequeue(Reusable.titleCell, for: indexPath)
      cell.dependency = self.titleCellDependency
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
    }
  }

  func background(
    collectionView: UICollectionView,
    kind: String,
    indexPath: IndexPath,
    sectionItem: SectionItem
  ) -> UICollectionReusableView {
    switch kind {
      case UICollectionElementKindSectionBackground:
        let view = collectionView.dequeue(Reusable.sectionBackgroundView, kind: kind, for: indexPath)
        view.backgroundColor = .white
        view.borderedLayer?.borders = [.top, .bottom]
        return view

      default:
        return collectionView.emptyView(for: indexPath, kind: kind)
      }
  }

  func cellPadding(
    _ collectionViewLayout: UICollectionViewFlexLayout,
    _ indexPath: IndexPath,
    _ sectionItem: SectionItem
  ) -> UIEdgeInsets {
    switch sectionItem {
    case .image:
      let sectionPadding = collectionViewLayout.padding(forSectionAt: indexPath.section)
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
    }
  }

  func cellVerticalSpacing(
    _ sectionItem: SectionItem,
    _ nextSectionItem: SectionItem
  ) -> CGFloat {
    switch (sectionItem, nextSectionItem) {
    case (.image, _): return 10
    case (.title, _): return 10
    case (.text, _): return 10
    case (.reaction, _): return 10
    }
  }

  func cellSize(
    _ collectionView: UICollectionView,
    _ maxWidth: CGFloat,
    _ indexPath: IndexPath,
    _ sectionItem: SectionItem
  ) -> CGSize {
    switch sectionItem {
    case let .image(cellReactor):
      return Reusable.imageCell.class.size(width: maxWidth, reactor: cellReactor)

    case let .title(cellReactor):
      return Reusable.titleCell.class.size(width: maxWidth, reactor: cellReactor)

    case let .text(cellReactor):
      return Reusable.textCell.class.size(width: maxWidth, reactor: cellReactor)

    case let .reaction(cellReactor):
      return Reusable.reactionCell.class.size(width: maxWidth, reactor: cellReactor)
    }
  }
}
