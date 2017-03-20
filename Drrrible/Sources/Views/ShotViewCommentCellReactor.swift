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
  var messageLabelText: NSAttributedString? { get }
}

struct ShotViewCommentCellReactor: ShotViewCommentCellReactorType {

  var messageLabelText: NSAttributedString?

  init(provider: ServiceProviderType, comment: Comment) {
    self.messageLabelText = try? NSAttributedString(htmlString: comment.body)
  }

}
