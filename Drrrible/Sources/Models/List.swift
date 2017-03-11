//
//  List.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Foundation

struct List<Element> {
  var items: [Element]
  var nextURL: URL?

  init(items: [Element], nextURL: URL? = nil) {
    self.items = items
    self.nextURL = nextURL
  }
}
