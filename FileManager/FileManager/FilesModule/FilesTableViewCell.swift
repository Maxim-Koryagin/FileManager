//
//  FilesTableViewCell.swift
//  FileManager
//
//  Created by kosmokos I on 05.12.2022.
//

import Foundation
import UIKit

final class FilesTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    lazy var fileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "system", size: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
   
    private func setupUI(){
        setupViews()
        setupConstraints()
        contentView.backgroundColor = .white
    }
    
    private func setupViews(){
        contentView.addSubview(fileLabel)
        contentView.addSubview(descriptionLabel)
    
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            fileLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            fileLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            
            descriptionLabel.topAnchor.constraint(equalTo: fileLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    func setup(description: String) {
        self.descriptionLabel.text = description
    }
    
}
