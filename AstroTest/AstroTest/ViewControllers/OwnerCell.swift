//
//  OwnerCell.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 30.10.2024.
//

import UIKit

class OwnerCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static var reuseIdentifier = "OwnerCell"
    private let network = NetworkService.shared
    
    // MARK: - Visual Components
    
    private let ownerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let ownerLoginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let gistIDLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
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
        ownerImageView.image = nil
        ownerLoginLabel.text = ""
        gistIDLabel.text = ""
        backgroundColor = .white
    }
    
    // MARK: - Open methods
    
    func configure(data: (loginOwner: String?,
                          avatarOwner: String?,
                          gistIDLabel: String?)) {
        ownerLoginLabel.text = data.loginOwner
        gistIDLabel.text = data.gistIDLabel
        network.loadImage(urlString: data.avatarOwner ?? "https://зоомагазин.рф/upload/iblock/32d/novorozhdennyy_kotenok_bez_mamy_kak_vykhazhivat.jpg") { result in
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
        contentView.addSubview(ownerImageView)
        contentView.addSubview(gistIDLabel)
        
        ownerLoginLabel.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        gistIDLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        NSLayoutConstraint.activate([
            ownerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            ownerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ownerImageView.heightAnchor.constraint(equalToConstant: 150),
            ownerImageView.widthAnchor.constraint(equalToConstant: 150),
            
            ownerLoginLabel.topAnchor.constraint(equalTo: ownerImageView.bottomAnchor, constant: 7),
            ownerLoginLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 350),
            ownerLoginLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: 7),
            ownerLoginLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor, constant: 7),
            
            gistIDLabel.topAnchor.constraint(equalTo: ownerLoginLabel.bottomAnchor, constant: 10),
            gistIDLabel.leftAnchor.constraint(equalTo: ownerLoginLabel.leftAnchor),
            gistIDLabel.rightAnchor.constraint(equalTo: ownerLoginLabel.rightAnchor),
            gistIDLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
        ])
    }
}
