//
//  GistListViewModel.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 26.10.2024.
//

import UIKit

// MARK: - GistListViewModelProtocol

protocol GistListViewModelProtocol {
    
    // MARK: - Properties
    
    var numberOfSections: Int { get }
    var numberOfRowsInSection: (_ section: Int) -> Int { get }
    var dataForRow: ((_ indexPath: IndexPath) -> (String?, String, String?)) { get }
    var updateView: (() -> Void)? { get set }
    var goToNextViewController: ((_ viewModel: GistDetailViewModel) -> Void)? { get set }
    
    // MARK: - Open methods
    
    func cellTaped(_ indexPath: IndexPath) -> Void
    func fetchNextGistsPage()
    func refreshGists()
    func isNeedLoadMoreGists(at index: Int) -> Bool
}

// MARK: - GistListViewModel

final class GistListViewModel: GistListViewModelProtocol {
    
    // MARK: - Private properties
    
    private var model: GistListModel = GistListModel()
    
    // MARK: - Properties
    
    var numberOfSections: Int {
        return 1
    }
    
    lazy var numberOfRowsInSection: (Int) -> Int = getNumberOfRowsInSection
    lazy var dataForRow: ((IndexPath) -> (String?, String, String?)) = getDataForRow
    var updateView: (() -> Void)?
    var goToNextViewController: ((_ viewModel: GistDetailViewModel) -> Void)?
    
    // MARK: - Init
    
    init() {
    }
    
    // MARK: - Open methods
    
    func cellTaped(_ indexPath: IndexPath) {
        GistDetailModel(gist: model.gistList[indexPath.item]) { gistDetailModel in
            let gistDetailViewModel = GistDetailViewModel(model: gistDetailModel)
            DispatchQueue.main.async {
                self.goToNextViewController?(gistDetailViewModel)
            }
        }
    }
    
    func fetchNextGistsPage() {
        model.fetchNextGistsPage {
            self.updateView?()
        }
    }
    
    func refreshGists() {
        model.refreshGists {
            self.updateView?()
        }
    }
    
    func isNeedLoadMoreGists(at index: Int) -> Bool {
        return index + 1 == model.gistList.count
    }
    
    // MARK: - Private methods
    
    private func getNumberOfRowsInSection(_ section: Int) -> Int {
        switch section {
        case 0:
            return model.gistList.count
        default:
            return 0
        }
    }
    
    private func getDataForRow(_ indexPath: IndexPath) -> (loginOwner: String?,
                                                           avatarOwner: String,
                                                           descriptionGist: String?) {
        return (model.gistList[indexPath.row].owner.login,
                model.gistList[indexPath.row].owner.avatarUrl,
                model.gistList[indexPath.row].description)
    }
}
