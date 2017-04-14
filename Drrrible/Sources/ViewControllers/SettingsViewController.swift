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
import ReactorKit
import ReusableKit
import RxDataSources

final class SettingsViewController: BaseViewController, View {

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

  override init() {
    super.init()
    self.title = "Settings".localized
    self.tabBarItem.image = UIImage(named: "tab-settings")
    self.tabBarItem.selectedImage = UIImage(named: "tab-settings-selected")
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

  func configure(reactor: SettingsViewReactor) {
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

    // Action
    self.tableView.rx.itemSelected(dataSource: self.dataSource)
      .map(Reactor.Action.selectItem)
      .bindTo(reactor.action)
      .addDisposableTo(self.disposeBag)

    self.tableView.rx.itemSelected(dataSource: self.dataSource)
      .subscribe(onNext: { [weak self] sectionItem in
        guard let `self` = self else { return }
        guard case .logout = sectionItem else { return }
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout".localized, style: .destructive) { _ in
          reactor.action.onNext(.logout)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        [logoutAction, cancelAction].forEach(actionSheet.addAction)
        self.present(actionSheet, animated: true, completion: nil)
      })
      .addDisposableTo(self.disposeBag)

    // State
    reactor.state.map { $0.sections }
      .bindTo(self.tableView.rx.items(dataSource: self.dataSource))
      .addDisposableTo(self.disposeBag)

    reactor.state.map { $0.navigation }
      .filterNil()
      .subscribe(onNext: { [weak self] navigation in
        guard let `self` = self else { return }
        switch navigation {
        case let .webView(url):
          let viewController = SFSafariViewController(url: url)
          self.present(viewController, animated: true, completion: nil)

        case .carteView:
          let viewController = CarteViewController()
          self.navigationController?.pushViewController(viewController, animated: true)

        case let .loginScreen(reactor):
          AppDelegate.shared.presentLoginScreen(reactor: reactor)
        }
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
