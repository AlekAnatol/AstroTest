//
//  FileDisplayModel.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 07.11.2024.
//

import Foundation

class FileDisplayModel {
    
    // MARK: - Private properties
    
    private var privateFile: File
    
    // MARK: - Properties
    
    var file: File {
        return privateFile
    }
    
    // MARK: - Init
    
    init(file: File) {
             self.privateFile = file
    }
}
