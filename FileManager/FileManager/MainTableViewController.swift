//
//  MainViewController.swift
//  FileManager
//
//  Created by kosmokos I on 03.12.2022.
//

import UIKit

class MainViewController: UITableViewController {
    
    //MARK: - Properties
    
    var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    var files: [String] {
        (try? FileManager.default.contentsOfDirectory(atPath: path)) ?? []
    }
   
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(path)
    }
    
    //MARK: - Methods
    
    @IBAction func addPhotoButton(_ sender: Any) {
        showImagePicker()
    }
    
    private func showImagePicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = "File"
        cell.detailTextLabel?.text = files[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fullPath = path + "/" + files[indexPath.row]
            try? FileManager.default.removeItem(atPath: fullPath)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }    
    }

}

//MARK: - Image picker data source

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
