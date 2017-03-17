//
//  SettingsViewController.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import SafariServices
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

  init(reactor: SettingsViewReactorType) {
    super.init()
    self.title = "Settings".localized
    self.tabBarItem.image = UIImage(named: "tab-settings")
    self.tabBarItem.selectedImage = UIImage(named: "tab-settings-selected")
    self.configure(reactor: reactor)
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

  private func configure(reactor: SettingsViewReactorType) {
    self.dataSource.configureCell = { dataSource, tableView, indexPath, sectionItem in
      let cell = tableView.dequeue(Reusable.cell, for: indexPath)
      switch sectionItem {
      case .version(let reactor):
        cell.configure(reactor: reactor)

      case .icons(let reactor):
        cell.configure(reactor: reactor)

      case .openSource(let reactor):
        cell.configure(reactor: reactor)

      case .logout(let reactor):
        cell.configure(reactor: reactor)
      }
      return cell
    }

    // Input
    self.tableView.rx.itemSelected(dataSource: self.dataSource)
      .bindTo(reactor.tableViewDidSelectItem)
      .addDisposableTo(self.disposeBag)

    // Output
    reactor.tableViewSections
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .addDisposableTo(self.disposeBag)

    reactor.presentWebViewController
      .subscribe(onNext: { [weak self] url in
        guard let `self` = self else { return }
        let viewController = SFSafariViewController(url: url)
        self.present(viewController, animated: true, completion: nil)
      })
      .addDisposableTo(self.disposeBag)

    reactor.presentCarteViewController
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.pushViewController(CarteViewController(), animated: true)
      })
      .addDisposableTo(self.disposeBag)

    reactor.presentLogoutAlert
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
              reactor.logoutAlertDidSelectActionItem.onNext(actionItem)
            }
          }
          .forEach(actionSheet.addAction)
        self.present(actionSheet, animated: true, completion: nil)
      })
      .addDisposableTo(self.disposeBag)

    reactor.presentLoginScreen
      .subscribe(onNext: { reactor in
        AppDelegate.shared.presentLoginScreen(reactor: reactor)
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
