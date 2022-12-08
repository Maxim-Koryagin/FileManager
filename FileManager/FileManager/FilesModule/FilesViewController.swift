//
//  FilesViewController.swift
//  FileManager
//
//  Created by kosmokos I on 05.12.2022.
//

import Foundation
import UIKit

final class FilesViewController: UIViewController {
    
    //MARK: Properties
    
    var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    var files: [String] {
        (try? FileManager.default.contentsOfDirectory(atPath: path)) ?? []
    }
    
    private lazy var addButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Add Photo", style: .plain, target: self, action: #selector(showImagePicker))
        button.tintColor = .systemCyan
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemGray6

        tableView.register(FilesTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.title = "File Manager"
        navigationItem.rightBarButtonItem = addButtonItem
    }
    
    private func setupViews(){
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    @objc
    private func showImagePicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
}

//MARK: - Table view data source

extension FilesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        files.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? FilesTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return cell
        }

        let fullPath = path + "/" + files[indexPath.row]
        
        var localFiles = self.files
        
        if UserDefaults.standard.string(forKey: "sort") == "on" {
            localFiles.sort(by: <)
        }
        
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
            if isDir.boolValue == true {
                cell.fileLabel.text = "Folder"
            } else {
                cell.fileLabel.text = "File"
            }
        }
    
        cell.descriptionLabel.text = localFiles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { _,_,_  in
            let fullPath = self.path + "/" + self.files[indexPath.row]
            try? FileManager.default.removeItem(atPath: fullPath)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

}

//MARK: - Image picker data source

extension FilesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        
        guard let imagePath = getDocumentPath()?.appending(component: imageName), let jpegData = image.jpegData(compressionQuality: 0.5)
        else { return }
        FileManager.default.createFile(atPath: imagePath.relativePath, contents: jpegData)
        tableView.reloadData()
        picker.dismiss(animated: true)
    }
    
    func getDocumentPath() -> URL? {
        do {
            let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            return url
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
