//
//  ShotViewImageCell.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import Kingfisher
import ReactorKit

final class ShotViewImageCell: BaseCollectionViewCell, ReactorKit.View {

  struct Dependency {
    let imageOptions: ImageOptions
  }


  // MARK: Properties

  var dependency: Dependency?


  // MARK: UI

  let imageView = AnimatedImageView()


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.imageView)
  }


  // MARK: Configuring

  func bind(reactor: ShotViewImageCellReactor) {
    guard let dependency = dependency else { preconditionFailure() }

    reactor.state.map { $0.imageURL }
      .bind(to: self.imageView.rx.image(options: dependency.imageOptions))
      .disposed(by: self.disposeBag)
  }


  // MARK: Size

  class func size(width: CGFloat, reactor: ShotViewImageCellReactor) -> CGSize {
    return CGSize(width: width, height: ceil(width * 3 / 4))
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    self.imageView.frame = self.contentView.bounds
  }

}
