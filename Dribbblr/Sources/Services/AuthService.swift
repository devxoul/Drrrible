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
}

final class AuthService: BaseService, AuthServiceType {

  fileprivate let clientID = ProcessInfo.processInfo.environment["OAUTH_CLIENT_ID"] ?? ""
  fileprivate let clientSecret = ProcessInfo.processInfo.environment["OAUTH_CLIENT_SECRET"] ?? ""

  fileprivate var currentViewController: UIViewController?
  fileprivate let callbackSubject = PublishSubject<String>()

  fileprivate let keychain = Keychain(service: "kr.xoul.dribbblr")
  private(set) var currentAccessToken: AccessToken?

  override init(provider: ServiceProviderType) {
    super.init(provider: provider)

    assert(!self.clientID.isEmpty, "Set environment variable 'OAUTH_CLIENT_ID'")
    assert(!self.clientSecret.isEmpty, "Set environment variable 'OAUTH_CLIENT_SECRET'")

    self.currentAccessToken = self.loadAccessToken()
    log.debug("currentAccessToken exists: \(self.currentAccessToken != nil)")
  }

  func authorize() -> Observable<Void> {
    let url = URL(string: "https://dribbble.com/oauth/authorize?client_id=\(self.clientID)")!

    // Default animation of presenting SFSafariViewController is similar to 'push' animation
    // (from right to left). To use 'modal' animation (from bottom to top), we have to wrap
    // SFSafariViewController with UINavigationController and set navigation bar hidden.
    let safariViewController = SFSafariViewController(url: url)
    let navigationController = UINavigationController(rootViewController: safariViewController)
    navigationController.isNavigationBarHidden = true
    Navigator.present(navigationController)
    self.currentViewController = navigationController

    return self.callbackSubject
      .flatMap(self.accessToken)
      .do(onNext: { [weak self] accessToken in
        try self?.saveAccessToken(accessToken)
        self?.currentAccessToken = accessToken
      })
      .map { _ in Void() }
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

}
