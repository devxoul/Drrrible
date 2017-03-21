//
//  ShotViewCommentCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ShotViewCommentCellReactorType {
  var avatarURL: URL? { get }
  var name: String { get }
  var message: NSAttributedString { get }
}

struct ShotViewCommentCellReactor: ShotViewCommentCellReactorType {

  let avatarURL: URL?
  let name: String
  let message: NSAttributedString

  init(provider: ServiceProviderType, comment: Comment) {
    self.avatarURL = comment.user.avatarURL
    self.name = comment.user.name
    self.message = (try? NSAttributedString(htmlString: comment.body))
      ?? NSAttributedString(string: comment.body)
  }

}
