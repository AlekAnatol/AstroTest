//
//  GistDetailViewModel.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 30.10.2024.
//

import Foundation

// MARK: - GistDetailViewModelProtocol

protocol GistDetailViewModelProtocol {
    
    // MARK: - Properties
    
    var numberOfSections: Int { get }
    var numberOfRowsInSection: (_ section: Int) -> Int { get }
    var dataForOwner: (() -> (String?, String?, String?)) { get }
    var dataForRow: ((_ indexPath: IndexPath) -> (String?)) { get }
    var updateView: (() -> Void)? { get set }
    var goToNextViewController: ((_ viewModel: FileDisplayViewModel) -> Void)? { get set }
    
    
    // MARK: - Open methods
    
    func cellTaped(_ indexPath: IndexPath)
    func refreshCommits()
}

// MARK: - GistDetailViewModel

final class GistDetailViewModel: GistDetailViewModelProtocol {
    
    // MARK: - Private properties
    
    private var model: GistDetailModel?
    
    // MARK: - Properties
    
    var numberOfSections: Int {
        return 3
    }
    
    lazy var numberOfRowsInSection: (Int) -> Int = getNumberOfRowsInSection
    lazy var dataForOwner: (() -> (String?, String?, String?)) = getDataForOwner
    lazy var dataForRow: ((_ indexPath: IndexPath) -> (String?)) = getDataForRow
    var updateView: (() -> Void)?
    var goToNextViewController: ((_ viewModel: FileDisplayViewModel) -> Void)?
    
    // MARK: - Init
    
    init(model: GistDetailModel) {
        self.model = model
    }
    
    // MARK: - Open methods
    
    func cellTaped(_ indexPath: IndexPath) {
        guard let model = model else { return }
        let fileDisplayModel = FileDisplayModel(file: model.filesDictionaryValues[indexPath.item - 1])
        let fileDisplayViewModel = FileDisplayViewModel(model: fileDisplayModel)
        goToNextViewController?(fileDisplayViewModel)
    }
    
    func refreshCommits() {
        model?.refreshCommits {
            self.updateView?()
        }
    }
    
    // MARK: - Private methods
    
    private func getNumberOfRowsInSection(_ section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return (model?.gist.files.count ?? 0) + 1
        case 2:
            return (model?.commits.count ?? 0) + 1
        default:
            return 0
        }
    }
    
    private func getDataForOwner() -> (loginOwner: String?,
                                                           avatarOwner: String?,
                                                           descriptionGist: String?) {
        return (model?.gist.owner.login,
                model?.gist.owner.avatarUrl,
                model?.gist.description)
    }
    
    private func getDataForRow(_ indexPath: IndexPath) -> String? {
        switch indexPath.section {
        case 1:
            return model?.filesDictionaryValues[indexPath.item - 1].filename
        case 2:
            return model?.commits[indexPath.item - 1].version
        default:
            return ""
        }
    }
}
