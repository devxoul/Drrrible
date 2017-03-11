//
//  ShotViewTextCellModel.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 12/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

protocol ShotViewTextCellModelType {
  var labelText: NSAttributedString? { get }
}

final class ShotViewTextCellModel: ShotViewTextCellModelType {
  let labelText: NSAttributedString?

  init(provider: ServiceProviderType, shot: Shot) {
    if let text = shot.text {
      self.labelText = try? NSAttributedString(htmlString: text)
    } else {
      self.labelText = nil
    }
  }
}
