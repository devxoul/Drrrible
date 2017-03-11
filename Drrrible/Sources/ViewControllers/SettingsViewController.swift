//
//  SettingsViewController.swift
//  Dribbblr
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import Carte
import ReusableKit
import RxDataSources

final class SettingsViewController: BaseViewController {

  // MARK: Constants

  fileprivate struct Reusable {
    static let cell = ReusableCell<SettingItemCell>()
  }


  // MARK: Properties

  fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SettingsViewSection>()


  // MARK: UI

  fileprivate let tableView = UITableView(frame: .zero, style: .grouped).then {
    $0.register(Reusable.cell)
  }


  // MARK: Initializing

  init(viewModel: SettingsViewModelType) {
    super.init()
    self.title = "Settings".localized
    self.tabBarItem.image = UIImage(named: "tab-settings")
    self.tabBarItem.selectedImage = UIImage(named: "tab-settings-selected")
    self.configure(viewModel: viewModel)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.tableView)
  }

  override func setupConstraints() {
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }


  // MARK: Configuring

  private func configure(viewModel: SettingsViewModelType) {
    self.dataSource.configureCell = { dataSource, tableView, indexPath, sectionItem in
      let cell = tableView.dequeue(Reusable.cell, for: indexPath)
      switch sectionItem {
      case .version(let cellModel):
        cell.configure(cellModel: cellModel)

      case .openSource(let cellModel):
        cell.configure(cellModel: cellModel)

      case .logout(let cellModel):
        cell.configure(cellModel: cellModel)
      }
      return cell
    }

    // Input
    self.tableView.rx.itemSelected(dataSource: self.dataSource)
      .bindTo(viewModel.tableViewDidSelectItem)
      .addDisposableTo(self.disposeBag)

    // Output
    viewModel.tableViewSections
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .addDisposableTo(self.disposeBag)

    viewModel.presentCarteViewController
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.pushViewController(CarteViewController(), animated: true)
      })
      .addDisposableTo(self.disposeBag)

    viewModel.presentLogoutAlert
      .subscribe(onNext: { [weak self] actionItems in
        guard let `self` = self else { return }
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionItems
          .map { actionItem -> UIAlertAction in
            let title: String
            let style: UIAlertActionStyle
            switch actionItem {
            case .logout:
              title = "Logout".localized
              style = .destructive

            case .cancel:
              title = "Cancel".localized
              style = .cancel
            }
            return UIAlertAction(title: title, style: style) { _ in
              viewModel.logoutAlertDidSelectActionItem.onNext(actionItem)
            }
          }
          .forEach(actionSheet.addAction)
        self.present(actionSheet, animated: true, completion: nil)
      })
      .addDisposableTo(self.disposeBag)

    viewModel.presentLoginScreen
      .subscribe(onNext: { viewModel in
        AppDelegate.shared.presentLoginScreen(viewModel: viewModel)
      })
      .addDisposableTo(self.disposeBag)

    // UI
    self.tableView.rx.itemSelected
      .subscribe(onNext: { [weak tableView] indexPath in
        tableView?.deselectRow(at: indexPath, animated: false)
      })
      .addDisposableTo(self.disposeBag)
  }

}
