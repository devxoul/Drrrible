//
//  AuthService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 08/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import SafariServices
import URLNavigator

import Alamofire
import KeychainAccess
import RxSwift

protocol AuthServiceType {
  var currentAccessToken: AccessToken? { get }

  /// Start OAuth authorization process.
  ///
  /// - returns: An Observable of `AccessToken` instance.
  func authorize() -> Observable<Void>

  /// Call this method when redirected from OAuth process to request access token.
  ///
  /// - parameter code: `code` from redirected url.
  func callback(code: String)

  func logout()
}

final class AuthService: AuthServiceType {

  fileprivate let clientID = "130182af71afe5247b857ef622bd344ca5f1c6144c8fa33c932628ac31c5ad78"
  fileprivate let clientSecret = "bbebedc51c2301049c2cb57953efefc30dc305523b8fdfadb9e9a25cb81efa1e"

  fileprivate var currentViewController: UIViewController?
  fileprivate let callbackSubject = PublishSubject<String>()

  fileprivate let keychain = Keychain(service: "com.drrrible.ios")
  private(set) var currentAccessToken: AccessToken?

  private let navigator: NavigatorType

  init(navigator: NavigatorType) {
    self.navigator = navigator
    self.currentAccessToken = self.loadAccessToken()
    log.debug("currentAccessToken exists: \(self.currentAccessToken != nil)")
  }

  func authorize() -> Observable<Void> {
    let parameters: [String: String] = [
      "client_id": self.clientID,
      "scope": "public+write+comment+upload",
    ]
    let parameterString = parameters.map { "\($0)=\($1)" }.joined(separator: "&")
    let url = URL(string: "https://dribbble.com/oauth/authorize?\(parameterString)")!

    // Default animation of presenting SFSafariViewController is similar to 'push' animation
    // (from right to left). To use 'modal' animation (from bottom to top), we have to wrap
    // SFSafariViewController with UINavigationController and set navigation bar hidden.
    let safariViewController = SFSafariViewController(url: url)
    let navigationController = UINavigationController(rootViewController: safariViewController)
    navigationController.isNavigationBarHidden = true
    self.navigator.present(navigationController)
    self.currentViewController = navigationController

    return self.callbackSubject
      .flatMap(self.accessToken)
      .do(onNext: { [weak self] accessToken in
        try self?.saveAccessToken(accessToken)
        self?.currentAccessToken = accessToken
      })
      .map { _ in }
  }

  func callback(code: String) {
    self.callbackSubject.onNext(code)
    self.currentViewController?.dismiss(animated: true, completion: nil)
    self.currentViewController = nil
  }

  func logout() {
    self.currentAccessToken = nil
    self.deleteAccessToken()
  }

  fileprivate func accessToken(code: String) -> Single<AccessToken> {
    let urlString = "https://dribbble.com/oauth/token"
    let parameters: Parameters = [
      "client_id": self.clientID,
      "client_secret": self.clientSecret,
      "code": code,
    ]
    return Single.create { observer in
      let request = Alamofire
        .request(urlString, method: .post, parameters: parameters)
        .responseData { response in
          switch response.result {
          case let .success(jsonData):
            do {
              let accessToken = try JSONDecoder().decode(AccessToken.self, from: jsonData)
              observer(.success(accessToken))
            } catch let error {
              observer(.error(error))
            }

          case let .failure(error):
            observer(.error(error))
          }
        }
      return Disposables.create {
        request.cancel()
      }
    }
  }

  fileprivate func saveAccessToken(_ accessToken: AccessToken) throws {
    try self.keychain.set(accessToken.accessToken, key: "access_token")
    try self.keychain.set(accessToken.tokenType, key: "token_type")
    try self.keychain.set(accessToken.scope, key: "scope")
  }

  fileprivate func loadAccessToken() -> AccessToken? {
    guard let accessToken = self.keychain["access_token"],
      let tokenType = self.keychain["token_type"],
      let scope = self.keychain["scope"]
    else { return nil }
    return AccessToken(accessToken: accessToken, tokenType: tokenType, scope: scope)
  }

  fileprivate func deleteAccessToken() {
    try? self.keychain.remove("access_token")
    try? self.keychain.remove("token_type")
    try? self.keychain.remove("scope")
  }

}
