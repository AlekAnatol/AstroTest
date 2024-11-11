//
//  GistCell.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 29.10.2024.
//

import UIKit

class GistCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "GistCell"
    private let network = NetworkService.shared
    
    // MARK: - Visual Components
    
    private let ownerLoginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 15)
        label.numberOfLines = 1
        return label
    }()
    
    private let gistDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 10)
        label.numberOfLines = 0
        return label
    }()
    
    private let ownerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func prepareForReuse() {
        ownerImageView.image = nil
        ownerLoginLabel.text = ""
        gistDescriptionLabel.text = ""
        backgroundColor = .white
    }
    
    // MARK: - Open methods
    
    func configure(data: (loginOwner: String?,
                          avatarOwner: String,
                          descriptionGist: String?)) {
        ownerLoginLabel.text = data.loginOwner
        gistDescriptionLabel.text = data.descriptionGist
        network.loadImage(urlString: data.avatarOwner) { result in
            var image = UIImage()
            switch result {
            case .success(let loadedImage):
                image = loadedImage
            case .failure(_):
                image = UIImage(systemName: "star")!
            }
            DispatchQueue.main.async {
                self.ownerImageView.image = image
            }
        }
    }
    
    // MARK: - Private methods
    
    private func layoutSubView() {
        contentView.addSubview(ownerLoginLabel)
        contentView.addSubview(gistDescriptionLabel)
        contentView.addSubview(ownerImageView)
        
        NSLayoutConstraint.activate([
            ownerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            ownerImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            ownerImageView.heightAnchor.constraint(equalToConstant: 60),
            ownerImageView.widthAnchor.constraint(equalToConstant: 60),
            
            ownerLoginLabel.topAnchor.constraint(equalTo: ownerImageView.topAnchor),
            ownerLoginLabel.leftAnchor.constraint(equalTo: ownerImageView.rightAnchor, constant: 15),
            ownerLoginLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            
            gistDescriptionLabel.topAnchor.constraint(equalTo: ownerLoginLabel.bottomAnchor, constant: 15),
            gistDescriptionLabel.leftAnchor.constraint(equalTo: ownerLoginLabel.leftAnchor),
            gistDescriptionLabel.rightAnchor.constraint(equalTo: ownerLoginLabel.rightAnchor),
            gistDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            gistDescriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
    }
}

