//
//  ShotViewTextCellReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

protocol ShotViewTextCellReactorType {
  var text: NSAttributedString? { get }
}

final class ShotViewTextCellReactor: ShotViewTextCellReactorType {
  let text: NSAttributedString?

  init(provider: ServiceProviderType, shot: Shot) {
    if let text = shot.text {
      self.text = try? NSAttributedString(htmlString: text)
    } else {
      self.text = nil
    }
  }
}
