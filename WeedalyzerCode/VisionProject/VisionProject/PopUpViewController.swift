//
//  PopUpViewController.swift
//  VisionProject
//
//  Created by Griffin Freudenberg on 3/30/24.
//

import UIKit

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var scientificName: UILabel!
    @IBOutlet weak var plantDescription: UILabel!
    @IBOutlet weak var detectionResultLabel: UILabel!
    @IBOutlet weak var popUpImage: UIImageView!
    var detectedPlant: String?
    var popupImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantDescription.numberOfLines = 0
       
        if let detectedPlant = detectedPlant {
            detectionResultLabel.textColor = UIColor.black
            scientificName.textColor = UIColor.black
            plantDescription.textColor = UIColor.black
            if detectedPlant == "dandelion"{
                detectionResultLabel.text = "Dandelion"
                scientificName.text = "Taraxacum"
                plantDescription.text = "A dandelion is a yellow-flowered plant with fluffy seed heads. It's known for its resilience and easily dispersing seeds."
            }
            if detectedPlant == "thistle"{
                detectionResultLabel.text = "Thistle"
                scientificName.text = "Cirsium"
            }
            if detectedPlant == "anything but plants"{
                detectionResultLabel.text = "Error. No Plant Detected"
            }
        }
        if let image = popupImage {
            popUpImage.layer.borderWidth = 4.0
            popUpImage.layer.borderColor = UIColor.black.cgColor
            popUpImage.image = image
            
        }
        
    }
}

