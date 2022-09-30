//
//  Extension+UIImageView.swift
//  tawkiOSTest
//
//  Created by Apple on 28/09/22.
//

import Foundation
import UIKit

// MARK: - UIImageView Extension
extension UIImageView {
    
    func invertColor(){
        DispatchQueue.main.async {
            let image = CIImage(cgImage: (self.image?.cgImage)!)
            let filter = CIFilter(name: "CIColorInvert")
            filter!.setDefaults()
            filter!.setValue(image, forKey: kCIInputImageKey)

            let context = CIContext(options: nil)
            let imageRef = context.createCGImage((filter?.outputImage!)!, from: image.extent)
            self.image = UIImage(cgImage: imageRef!)
        }
    }
}
