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
    var presentAlertClosure: (() -> Void)?
    
    func presentErrorAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let alertController = UIAlertController(title: "Error", message: "No plant detected", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
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
            else if detectedPlant == "thistle"{
                detectionResultLabel.text = "Thistle"
                scientificName.text = "Cirsium"
            }
            else if detectedPlant == "anything but plants"{
                errorLabel.text = "Error. No Plant Detected"
                self.view.backgroundColor = UIColor.red
                commonName.text = ""
                scientificNameLabel.text = ""
                descriptionBox.text = ""
                presentAlertClosure?()
            }
            
            
        }
        
        if let image = popupImage {
            popUpImage.layer.borderWidth = 4.0
            popUpImage.layer.borderColor = UIColor.black.cgColor
            popUpImage.image = image
            
        }
        
    }
}

