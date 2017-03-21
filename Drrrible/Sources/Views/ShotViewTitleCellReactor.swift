//
//  ShotViewTitleCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ShotViewTitleCellReactorType {
  // Output
  var avatarURL: URL? { get }
  var title: String { get }
  var username: String { get }
}

final class ShotViewTitleCellReactor: ShotViewTitleCellReactorType {

  // MARK: Input

  // MARK: Output

  let avatarURL: URL?
  let title: String
  let username: String


  // MARK: Initializing

  init(provider: ServiceProviderType, shot: Shot) {
    self.avatarURL = shot.user.avatarURL
    self.title = shot.title
    self.username = "by \(shot.user.name)"
  }

}
