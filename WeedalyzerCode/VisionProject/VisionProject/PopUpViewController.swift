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
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var descriptionBox: UILabel!
    @IBOutlet weak var detectionResultLabel: UILabel!
    @IBOutlet weak var commonName: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
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
            errorLabel.textColor = UIColor.black
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
                errorLabel.text = "Error. No Plant Detected"
                self.view.backgroundColor = UIColor.red
                commonName.text = ""
                scientificNameLabel.text = ""
                descriptionBox.text = ""
                let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        if let image = popupImage {
            popUpImage.layer.borderWidth = 4.0
            popUpImage.layer.borderColor = UIColor.black.cgColor
            popUpImage.image = image
            
        }
        
    }
}

