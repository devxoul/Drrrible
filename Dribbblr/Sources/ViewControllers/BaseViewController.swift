//
//  BaseViewController.swift
//  Dribbble
//
//  Created by Suyeol Jeon on 10/02/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {

  // MARK: Properties

  lazy private(set) var className: String = {
    return type(of: self).description().components(separatedBy: ".").last ?? ""
  }()


  // MARK: Initializing

  init() {
    super.init(nibName: nil, bundle: nil)
//    self.navigationItem.back
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
  }

  deinit {
    log.verbose("DEINIT: \(self.className)")
  }


  // MARK: Rx

  let disposeBag = DisposeBag()


  // MARK: Layout Constraints

  private(set) var didSetupConstraints = false

  override func viewDidLoad() {
    self.view.setNeedsUpdateConstraints()
  }

  override func updateViewConstraints() {
    if !self.didSetupConstraints {
      self.setupConstraints()
      self.didSetupConstraints = true
    }
    super.updateViewConstraints()
  }

  func setupConstraints() {
    // Override point
  }

}
