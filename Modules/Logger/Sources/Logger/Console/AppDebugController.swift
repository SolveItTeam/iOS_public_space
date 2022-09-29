//
//  AppDebugController.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit

/// Delegate protocol for handling events from `AppDebugController`
protocol AppDebugControllerDelegate: AnyObject {
    func appDebugControllerDidPressClose()
    func appDebugControllerDidSelect(_ option: AppDebugOption)
}

/// ViewController object represents all available `Console` options from `AppDebugOption`.
/// In footer of the screen show application version and server base URL
final class AppDebugController: UIViewController {
    private let options = AppDebugOption.allCases
    private let baseServerPath: String
    private weak var delegate: AppDebugControllerDelegate?
    
    private lazy var tableView: UITableView = {
        var view: UITableView!
        if #available(iOS 13.0, *) {
            view = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            view = UITableView(frame: .zero, style: .plain)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Initialization
    init(
        delegate: AppDebugControllerDelegate,
        baseServerPath: String
    ) {
        self.baseServerPath = baseServerPath
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "App Debug"
        setupTableView()
        navigationItem.leftBarButtonItem = makeCloseItem()
        tableView.tableFooterView = makeAppVersionLabel()
    }
    
    //MARK: - Actions
    @objc private func closePressed() {
        delegate?.appDebugControllerDidPressClose()
    }
}

//MARK: - Make Views
private extension AppDebugController {
    func makeCloseItem() -> UIBarButtonItem {
        if #available(iOS 13.0, *) {
            return .init(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(closePressed)
            )
        } else {
            return .init(
                title: "Close",
                style: .plain,
                target: self,
                action: #selector(closePressed)
            )
        }
    }
    
    func makeAppVersionLabel() -> UILabel {
        let view = UILabel(frame:
            .init(
                origin: .zero,
                size: .init(width: view.bounds.width, height: 50)
            )
        )
        view.numberOfLines = 0
        view.text = "App version: \(UIApplication.shared.version)\nServer: \(baseServerPath)"
        view.textAlignment = .center
        return view
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: - UITableViewDelegate
extension AppDebugController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = options[indexPath.row]
        delegate?.appDebugControllerDidSelect(option)
    }
}

//MARK: - UITableViewDataSource
extension AppDebugController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = .init(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = options[indexPath.row].rawValue.uppercased()
        return cell!
    }
}
