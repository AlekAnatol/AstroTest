//
//  GistDetailViewController.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 30.10.2024.
//

import UIKit

class GistDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: GistDetailViewModelProtocol?
    
    // MARK: - Visual components
    
    lazy var detailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    var refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl.addTarget(self, action: #selector(refreshCommits), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(#colorLiteral(red: 0, green: 0.3351471424, blue: 0.5525879264, alpha: 1))
        setupViewModel()
        setupDetailCollectionView()
        setupView()
    }
    
    // MARK: - Private methods
    
    private func setupViewModel() {
        viewModel?.goToNextViewController = { fileDisplayViewModel in
            let nextViewController = FileDisplayViewController()
            nextViewController.viewModel = fileDisplayViewModel
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        viewModel?.updateView = {[weak self] in
            DispatchQueue.main.async {
                self?.detailCollectionView.reloadSections(IndexSet(integer: 2))
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupDetailCollectionView() {
        detailCollectionView.register(OwnerCell.self, forCellWithReuseIdentifier: OwnerCell.reuseIdentifier)
        detailCollectionView.register(StandartCollectionCell.self, forCellWithReuseIdentifier: StandartCollectionCell.reuseIdentifier)
    }
    
    private func setupView() {
        view.addSubview(detailCollectionView)
        detailCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        detailCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        detailCollectionView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        detailCollectionView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        detailCollectionView.refreshControl = refreshControl
    }
    
    // MARK: - Actions
    
    @objc func refreshCommits() {
        refreshControl.beginRefreshing()
        viewModel?.refreshCommits()
    }
}

// MARK: - UICollectionViewDataSource

extension GistDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerCell.reuseIdentifier, for: indexPath) as? OwnerCell else { return UICollectionViewCell() }
            let data = viewModel?.dataForOwner() ?? (nil, nil, nil)
            cell.configure(data: data)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandartCollectionCell.reuseIdentifier, for: indexPath) as? StandartCollectionCell else { return UICollectionViewCell() }
            if indexPath.item == 0 {
                if indexPath.section == 1 {
                    cell.configure(data: "Files", isHeader: true)
                }
                if indexPath.section == 2 {
                    cell.configure(data: "Commits", isHeader: true)
                }
            } else {
                let data = viewModel?.dataForRow(indexPath)
                cell.configure(data: data, isHeader: false)
            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension GistDetailViewController: UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            viewModel?.cellTaped(indexPath)
        }
    }
}
