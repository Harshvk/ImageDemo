//
//  ImageEditingVC.swift
//  ImageDemo
//
//  Created by Harsh Vardhan Kushwaha on 06/11/22.
//

import UIKit
import swift_vibrant

class ImageEditingVC: UIViewController {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: HVKStickerImageView!
    @IBOutlet private weak var shuffleColorsButton: UIButton!
    @IBOutlet private weak var addTextButton: UIButton!
    @IBOutlet private weak var addImageButton: UIButton!
    @IBOutlet private weak var saveToPhotosButton: UIButton!

    private var viewModel = ImageEditingVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupImageView()
        // Do any additional setup after loading the view.
    }
    
    func setupData(image:UIImage) {
        self.viewModel.originalImage = image
    }
    
    private func setupImageView(){
        guard let image = viewModel.originalImage else {return}
        let colors = Vibrant.from(image).getPalette()
        if let darkVibrant = colors.DarkVibrant, let lightVibrant = colors.LightVibrant{
            containerView.addGradientLayerInBackground(frame: imageView.bounds, colors: [darkVibrant.uiColor,lightVibrant.uiColor])
        }
        imageView.image = image
    }
    
    @IBAction func shuffleColorsButtonAction(_ sender: UIButton) {
        let color1 = UIColor.random()
        let color2 = UIColor.random()
        containerView.addGradientLayerInBackground(frame: imageView.bounds, colors: [color1,color2])
    }
    
    @IBAction func addTextButtonAction(_ sender: UIButton) {
        imageView.addLabel()
        imageView.currentlyEditingLabel.border?.strokeColor = UIColor.white.cgColor
        imageView.currentlyEditingLabel.labelTextView?.font = UIFont.systemFont(ofSize: 14.0)
        imageView.currentlyEditingLabel.labelTextView?.becomeFirstResponder()
    }
    
    @IBAction func addImageButtonAction(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveToPhotosButtonAction(_ sender: UIButton) {
        let image = containerView.asImage()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}

extension ImageEditingVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {return}
        imageView.addImage(image: image)
    }
}

extension ImageEditingVC: ImageEditingVMDelegate {
    
}


