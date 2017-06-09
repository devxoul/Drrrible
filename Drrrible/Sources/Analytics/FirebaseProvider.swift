//
//  FirebaseProvider.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/06/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import EventAnalytics
import Firebase

final class FirebaseProvider: ProviderType {
  func log(_ eventName: String, parameters: [String : Any]?) {
    Firebase.Analytics.logEvent(eventName, parameters: parameters)
  }
}
