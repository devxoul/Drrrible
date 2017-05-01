//
//  UIImageView+Kingfisher.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 01/05/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift

enum ImageResult {
  case success(UIImage)
  case failure(Error)

  var image: UIImage? {
    if case .success(let image) = self {
      return image
    } else {
      return nil
    }
  }

  var error: Error? {
    if case .failure(let error) = self {
      return error
    } else {
      return nil
    }
  }
}

extension UIImageView {
  @discardableResult
  func setImage(
    with resource: Resource?,
    placeholder: UIImage? = nil,
    progress: ((Int64, Int64) -> Void)? = nil,
    completion: ((ImageResult) -> Void)? = nil
  ) -> RetrieveImageTask {
    // GIF will only animates in the AnimatedImageView
    let options: KingfisherOptionsInfo? = (self is AnimatedImageView) ? nil : [.onlyLoadFirstFrame]
    let completionHandler: CompletionHandler = { image, error, cacheType, url in
      if let image = image {
        completion?(.success(image))
      } else if let error = error {
        completion?(.failure(error))
      }
    }
    return self.kf.setImage(
      with: resource,
      placeholder: placeholder,
      options: options,
      progressBlock: progress,
      completionHandler: completionHandler
    )
  }
}

extension Reactive where Base: UIImageView {
  var resource: UIBindingObserver<Base, Resource?> {
    return self.resource(placeholder: nil)
  }

  func resource(placeholder: UIImage? = nil) -> UIBindingObserver<Base, Resource?> {
    return UIBindingObserver(UIElement: self.base) { imageView, resource in
      imageView.setImage(with: resource, placeholder: placeholder)
    }
  }
}
