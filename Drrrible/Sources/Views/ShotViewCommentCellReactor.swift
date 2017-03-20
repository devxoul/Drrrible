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
  var avatarViewURL: URL? { get }
  var nameLabelText: String { get }
  var messageLabelText: NSAttributedString { get }
}

struct ShotViewCommentCellReactor: ShotViewCommentCellReactorType {

  let avatarViewURL: URL?
  let nameLabelText: String
  let messageLabelText: NSAttributedString

  init(provider: ServiceProviderType, comment: Comment) {
    self.avatarViewURL = comment.user.avatarURL
    self.nameLabelText = comment.user.name
    self.messageLabelText = (try? NSAttributedString(htmlString: comment.body))
      ?? NSAttributedString(string: comment.body)
  }

}
