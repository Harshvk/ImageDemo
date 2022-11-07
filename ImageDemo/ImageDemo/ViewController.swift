//
//  ViewController.swift
//  ImageDemo
//
//  Created by Harsh Vardhan Kushwaha on 06/11/22.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var pickImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickImageButton.setTitle("Pick up image", for: .normal)
        // Do any additional setup after loading the view.
    }

    @IBAction func pickButtonAction(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {return}
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageEditingVC") as? ImageEditingVC {
            vc.setupData(image: image)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
