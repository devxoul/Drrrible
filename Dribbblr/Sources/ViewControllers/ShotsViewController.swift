//
//  ShotsViewController.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class ShotsViewController: BaseViewController {

  // MARK: Initializing

  init(viewModel: ShotsViewModelType) {
    super.init()
    self.configure(input: viewModel)
    self.configure(output: viewModel)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  private func configure(input: ShotsViewModelInput) {
  }

  private func configure(output: ShotsViewModelOutput) {
  }

}
