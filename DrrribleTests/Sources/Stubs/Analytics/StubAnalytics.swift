//
//  StubAnalytics.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 15/08/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Umbrella
@testable import Drrrible

final class StubAnalytics: Analytics<AnalyticsEvent> {
  private(set) var events: [Event] = []

  override func log(_ event: Event) {
    self.events.append(event)
  }
}

extension Analytics where Event == AnalyticsEvent {
  static func stub() -> Analytics {
    return StubAnalytics()
  }
}
