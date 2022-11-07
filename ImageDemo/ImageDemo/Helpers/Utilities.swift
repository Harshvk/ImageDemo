//
//  Utilities.swift
//  ImageDemo
//
//  Created by Harsh Vardhan Kushwaha on 06/11/22.
//

import Foundation
import UIKit

extension UIView{
    func addGradientLayerInBackground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        gradient.name = "BgGradient"
        self.layer.sublayers?.first(where: {$0.name == "BgGradient"})?.removeFromSuperlayer()
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
        )
    }
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
