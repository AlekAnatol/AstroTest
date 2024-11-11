//
//  FileDisplayViewModel.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 07.11.2024.
//

import Foundation

// MARK: - FileDisplayViewModelProtocol

protocol FileDisplayViewModelProtocol {
    
    // MARK: - Properties
    
    var urlString: String? { get }
    
}

// MARK: - FileDisplayViewModel

final class FileDisplayViewModel: FileDisplayViewModelProtocol {
    
    // MARK: - Private properties
    
    private var model: FileDisplayModel?
    
    // MARK: - Properties
    
    var urlString: String? {
        model?.file.rawUrl
    }
    
    // MARK: - Init
    
    init(model: FileDisplayModel) {
        self.model = model
    }
}
