//
//  imagePreviewController.swift
//  EmergencyInfo
//
//  Created by MacBook on 6/26/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import UIKit

protocol ImagePreviewDelegate: class {
    func didAcceptedAvatar(image: UIImage?)
}
class ImagePreviewController: UIViewController {
    var image: UIImage?
    weak var delegateImagePreview: ImagePreviewDelegate?
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func btnCancel_Tapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSetAvatar_Tapped(_ sender: UIButton) {
        delegateImagePreview?.didAcceptedAvatar(image: image)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image

    }
}
