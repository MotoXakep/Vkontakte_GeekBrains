//
//  AddNewsViewController.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 05.03.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddNewsViewController: UIViewController {
    var newsRouter = NewsRouter()
    var codeRequest = 0
    
    @IBOutlet weak var startText: UILabel!
    @IBOutlet weak var newText: UITextView!
    @IBOutlet weak var newImage: UIImageView!
    
    @IBAction func sendNewButton(_ sender: Any) {
        post(text: newText.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func unwindToNewText(segue: UIStoryboardSegue) {
        guard segue.identifier == "backToNewText" else { return }
        guard let mvc = segue.source as? MapViewController else { return }
        self.newText.text.append( "\n\n" + mvc.adress)
    }
    
    func post(text: String) {
        if !text.isEmpty {
            newsRouter.postNewText(message: newText.text) { [weak self] code in
                self?.codeRequest = code
                self?.showAlert(self?.codeRequest)
            }
        } else {
            codeRequest = 1
            showAlert(codeRequest)
        }
    }
    
    
}

extension AddNewsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func addPhoto(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        camera.allowsEditing = false
        camera.delegate = self
        present(camera, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String else { return }
        
        if
            mediaType == kUTTypeImage as String,
            let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImage.image = originalImage
            let imageData = UIImagePNGRepresentation(originalImage)!
            newsRouter.photoPostToWall(image: imageData) { [weak self] done in
                if done {
                    self?.showAlert(200)
                } else {
                    self?.showAlert(.none)
                }
                
            }
        }
        
        if mediaType == kUTTypeMovie as String {
            if let movePath = (info[UIImagePickerControllerMediaURL] as? URL)?.path {
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(movePath) {}
                UISaveVideoAtPathToSavedPhotosAlbum(movePath, nil, nil, nil)
            }
       }
        
       picker.dismiss(animated: true, completion: nil)
}



}


extension AddNewsViewController {
    
    func showAlert (_ code: Int?) {
        var ac: UIAlertController
        switch code {
        case 200?:
            ac = UIAlertController(title: "Успешно!", message: "Запись опубликована на вашей стене", preferredStyle: .alert)
        case 1?:
            ac = UIAlertController(title: "Ошибка!", message: "Введите текст новости!", preferredStyle: .alert)
        case .none:
            ac = UIAlertController(title: "Ошибка!", message: "Ошибка запроса, повторите позднее.", preferredStyle: .alert)
        case .some(_):
            ac = UIAlertController(title: "Ошибка!", message: "Код ошибки: \(String(describing: code))", preferredStyle: .alert)
        }
        
        let ok = UIAlertAction(title: "Понятно!", style: .default) { (action) in
            self.backToNews()
        }
        
        ac.addAction(ok)
        self.present(ac, animated: true)
    }
    
    func backToNews() {
        performSegue(withIdentifier: "backToNews", sender: nil)
    }
}


