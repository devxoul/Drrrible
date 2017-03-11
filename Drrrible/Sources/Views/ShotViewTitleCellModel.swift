//
//  ShotViewTitleCellModel.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ShotViewTitleCellModelType {
  // Output
  var avatarViewURL: URL? { get }
  var titleLabelText: String { get }
  var usernameLabelText: String { get }
}

final class ShotViewTitleCellModel: ShotViewTitleCellModelType {

  // MARK: Input

  // MARK: Output

  let avatarViewURL: URL?
  let titleLabelText: String
  let usernameLabelText: String


  // MARK: Initializing

  init(provider: ServiceProviderType, shot: Shot) {
    self.avatarViewURL = shot.user.avatarURL
    self.titleLabelText = shot.title
    self.usernameLabelText = "by \(shot.user.name)"
  }

}
