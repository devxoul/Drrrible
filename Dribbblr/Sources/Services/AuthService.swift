//
//  AuthService.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import SafariServices
import URLNavigator

import Alamofire
import RxSwift

protocol AuthServiceType {
  /// Start OAuth authorization process.
  ///
  /// - returns: An Observable of `AccessToken` instance.
  func authorize() -> Observable<AccessToken>

  /// Call this method when redirected from OAuth process to request access token.
  ///
  /// - parameter code: `code` from redirected url.
  func callback(code: String)
}

final class AuthService: BaseService, AuthServiceType {

  fileprivate let clientID = "130182af71afe5247b857ef622bd344ca5f1c6144c8fa33c932628ac31c5ad78"
  fileprivate let clientSecret = "cb9e01074d67c87f5369cc40571e989d26a4c8a1891c126998b243b784ff5c79"

  fileprivate var currentViewController: UIViewController?
  fileprivate let callbackSubject = PublishSubject<String>()

  func authorize() -> Observable<AccessToken> {
    let url = URL(string: "https://dribbble.com/oauth/authorize?client_id=\(self.clientID)")!

    // Default animation of presenting SFSafariViewController is similar to 'push' animation
    // (from right to left). To use 'modal' animation (from bottom to top), we have to wrap
    // SFSafariViewController with UINavigationController and set navigation bar hidden.
    let safariViewController = SFSafariViewController(url: url)
    let navigationController = UINavigationController(rootViewController: safariViewController)
    navigationController.isNavigationBarHidden = true
    Navigator.present(navigationController)
    self.currentViewController = navigationController

    return self.callbackSubject.flatMap(self.accessToken)
  }

  func callback(code: String) {
    self.callbackSubject.onNext(code)
    self.currentViewController?.dismiss(animated: true, completion: nil)
    self.currentViewController = nil
  }

  fileprivate func accessToken(code: String) -> Observable<AccessToken> {
    let urlString = "https://dribbble.com/oauth/token"
    let parameters: Parameters = [
      "client_id": self.clientID,
      "client_secret": self.clientSecret,
      "code": code,
    ]
    return Observable.create { observer in
      let request = Alamofire
        .request(urlString, method: .post, parameters: parameters)
        .responseString { response in
          switch response.result {
          case .success(let jsonString):
            do {
              let accessToken = try AccessToken(JSONString: jsonString)
              observer.onNext(accessToken)
              observer.onCompleted()
            } catch let error {
              observer.onError(error)
            }

          case .failure(let error):
            observer.onError(error)
          }
        }
      return Disposables.create {
        request.cancel()
      }
    }
  }

}
