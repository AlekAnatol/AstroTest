//
//  StandartCollectionCell.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 05.11.2024.
//

import UIKit

class StandartCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static var reuseIdentifier = "StandartCollectionCell"
    
    // MARK: - Visual Components
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func prepareForReuse() {
        dataLabel.font = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 15)
        dataLabel.textAlignment = .left
        dataLabel.text = ""
        backgroundColor = .white
    }
    
    // MARK: - Open methods
    
    func configure(data: String?, isHeader: Bool) {
        dataLabel.text = data
        if isHeader {
            dataLabel.font = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 18)
            dataLabel.textAlignment = .center
        }
    }
    
    // MARK: - Private methods
    
    private func layoutSubView() {
        contentView.addSubview(dataLabel)
        
        NSLayoutConstraint.activate([
            dataLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 3),
            dataLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: 3),
            dataLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: 3),
            dataLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor, constant: -3),
            dataLabel.widthAnchor.constraint(equalToConstant: 348)
        ])
    }
}
