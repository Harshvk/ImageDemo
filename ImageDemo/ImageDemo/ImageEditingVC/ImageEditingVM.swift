//
//  ImageEditingVM.swift
//  ImageDemo
//
//  Created by Harsh Vardhan Kushwaha on 06/11/22.
//

import Foundation
import UIKit

protocol ImageEditingVMDelegate: AnyObject {
    
}

class ImageEditingVM {
    weak var delegate: ImageEditingVMDelegate?
    
    var textData:UITextView?
    var imageOverlay:UIImageView?
    var originalImage:UIImage?
    
}
