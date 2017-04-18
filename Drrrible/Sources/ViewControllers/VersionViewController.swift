//
//  VersionViewController.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import ReusableKit

final class VersionViewController: BaseViewController, View {

  // MARK: Constants

  fileprivate struct Reusable {
    static let cell = ReusableCell<VersionCell>()
  }

  fileprivate struct Metric {
    static let iconViewTop = 35.f
    static let iconViewSize = 100.f
    static let iconViewBottom = 0.f
  }


  // MARK: UI

  fileprivate let iconView = UIImageView(image: #imageLiteral(resourceName: "Icon512")).then {
    $0.layer.borderColor = UIColor.db_border.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = Metric.iconViewSize * 13.5 / 60
    $0.layer.minificationFilter = kCAFilterTrilinear
    $0.clipsToBounds = true
  }
  fileprivate let tableView = UITableView(frame: .zero, style: .grouped).then {
    $0.register(Reusable.cell)
  }


  // MARK: Initializing

  init(reactor: VersionViewReactor) {
    defer { self.reactor = reactor }
    super.init()
    self.title = "version".localized
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .db_background
    self.tableView.dataSource = self
    self.tableView.contentInset.top = Metric.iconViewTop + Metric.iconViewSize + Metric.iconViewBottom
    self.tableView.addSubview(self.iconView)
    self.view.addSubview(self.tableView)
  }

  override func setupConstraints() {
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.iconView.snp.makeConstraints { make in
      make.top.equalTo(Metric.iconViewTop - self.tableView.contentInset.top)
      make.centerX.equalToSuperview()
      make.size.equalTo(Metric.iconViewSize)
    }
  }


  // MARK: Binding

  func bind(reactor: VersionViewReactor) {
    // Action
    self.rx.viewWillAppear
      .map { _ in Reactor.Action.checkForUpdates }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State
    reactor.state
      .subscribe(onNext: { [weak self] _ in
        self?.tableView.reloadData()
      })
      .disposed(by: self.disposeBag)
  }

}

extension VersionViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(Reusable.cell, for: indexPath)
    if indexPath.row == 0 {
      cell.textLabel?.text = "current_version".localized
      cell.detailTextLabel?.text = self.reactor?.currentState.currentVersion
      cell.isLoading = false
    } else {
      cell.textLabel?.text = "latest_version".localized
      cell.detailTextLabel?.text = self.reactor?.currentState.latestVersion
      cell.isLoading = self.reactor?.currentState.isLoading ?? false
    }
    return cell
  }

}

private final class VersionCell: UITableViewCell {
  fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  override var accessoryView: UIView? {
    didSet {
      if self.accessoryView === self.activityIndicatorView {
        self.activityIndicatorView.startAnimating()
      } else {
        self.activityIndicatorView.stopAnimating()
      }
    }
  }

  var isLoading: Bool {
    get { return self.activityIndicatorView.isAnimating }
    set { self.accessoryView = newValue ? self.activityIndicatorView : nil }
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
