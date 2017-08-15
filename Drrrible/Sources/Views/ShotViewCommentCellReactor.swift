//
//  ShotViewCommentCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 21/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class ShotViewCommentCellReactor: Reactor {
  typealias Action = NoAction

  struct State {
    var avatarURL: URL?
    var name: String
    var message: NSAttributedString
  }

  let initialState: State

  init(comment: Comment) {
    self.initialState = State(
      avatarURL: comment.user.avatarURL,
      name: comment.user.name,
      message: (try? NSAttributedString(htmlString: comment.body))
        ?? NSAttributedString(string: comment.body)
    )
    _ = self.state
  }
}
