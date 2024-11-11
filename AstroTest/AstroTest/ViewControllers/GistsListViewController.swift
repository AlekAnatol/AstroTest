//
//  GistsTableViewController.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 25.10.2024.
//

import UIKit

class GistListViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: GistListViewModelProtocol = GistListViewModel()
    
    // MARK: - Visual components
    
    var gistTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    var refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl.addTarget(self, action: #selector(refreshGists), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(#colorLiteral(red: 0, green: 0.3351471424, blue: 0.5525879264, alpha: 1))
        setupViewModel()
        setupGistTableView()
        setupView()
        fetchGists()
    }
    
    // MARK: - Private methods
    
    private func setupViewModel() {
        viewModel.updateView = {[weak self] in
            DispatchQueue.main.async {
                self?.gistTableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        viewModel.goToNextViewController = { detailViewModel in
            let nextViewController = GistDetailViewController()
            nextViewController.viewModel = detailViewModel
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    private func setupGistTableView() {
        gistTableView.dataSource = self
        gistTableView.delegate = self
        gistTableView.register(GistCell.self, forCellReuseIdentifier: GistCell.reuseIdentifier)
    }
    
    private func setupView() {
        view.addSubview(gistTableView)
        gistTableView.refreshControl = refreshControl
        gistTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        gistTableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        gistTableView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        gistTableView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
    }
    
    private func fetchGists() {
        viewModel.fetchNextGistsPage()
    }
    
    // MARK: - Actions
    
    @objc func refreshGists() {
        refreshControl.beginRefreshing()
        viewModel.refreshGists()
    }
}

// MARK: - UITableViewDataSource

extension GistListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GistCell.reuseIdentifier) as? GistCell else {
            return UITableViewCell()
        }
        let dataForCell = viewModel.dataForRow(indexPath)
        cell.configure(data: dataForCell)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GistListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellTaped(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.isNeedLoadMoreGists(at: indexPath.row) {
            viewModel.fetchNextGistsPage()
        }
    }
}
