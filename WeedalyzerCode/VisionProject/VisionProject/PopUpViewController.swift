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
                plantDescription.text = "Recognizable by its bright yellow flowers and distinctive spherical seed heads, this perennial herbaceous plant thrives in various habitats worldwide. Often considered a weed, it serves as an important food source for pollinators and possesses medicinal properties in herbal medicine traditions."
            }
            else if detectedPlant == "johnson grass"{
                detectionResultLabel.text = "Johnson Grass"
                scientificName.text = "Sorghum Halepense"
                plantDescription.text = "Vigorous perennial grass notorious for its towering stature and pervasive rhizomes, thriving in warm climates and presenting a formidable obstacle in agricultural settings. Its persistent growth and resilience make eradication efforts arduous, often requiring a multifaceted approach combining mechanical, chemical, and cultural methods."
            }
            else if detectedPlant == "crabgrass"{
                detectionResultLabel.text = "Crabgrass"
                scientificName.text = "Digitaria"
                plantDescription.text = "Tenacious annual weed characterized by its prostrate growth habit, rapid spread, and resilience to adverse conditions, particularly prevalent in warm climates. Its ability to quickly colonize lawns and outcompete desirable turfgrass species challenges homeowners seeking a pristine lawn aesthetic, necessitating diligent management strategies to control its proliferation."
            }
            else if detectedPlant == "clover"{
                detectionResultLabel.text = "Clover"
                scientificName.text = "Trifolium"
                plantDescription.text = "Enduring perennial herb celebrated for its trifoliate leaves, nitrogen-fixing abilities, and delicate flowers, contributing to soil enrichment and biodiversity in various habitats. Embraced for its ecological benefits, clover serves as a valuable forage crop, aids in erosion control, and adds aesthetic charm to landscapes, embodying a harmonious blend of utility and natural beauty."
            }
            else if detectedPlant == "thistle"{
                detectionResultLabel.text = "Thistle"
                scientificName.text = "Cirsium"
                plantDescription.text = "Thistle is a flowering plant known for its prickly leaves and vibrant purple or pink flower heads. It thrives in diverse environments, from grasslands to rocky slopes, and serves as food and habitat for insects and birds. Despite its thorny appearance, thistle is admired for its beauty and has cultural significance in art and literature."
            }
            else if detectedPlant == "poison ivy"{
                detectionResultLabel.text = "Poison Ivy"
                scientificName.text = "Toxicodendron Radicans"

                plantDescription.text = "Poison ivy is a notorious plant known for its irritating oil, urushiol, causing allergic reactions in humans upon contact. Characterized by clusters of three leaflets, it thrives in various habitats across North America. Despite its toxicity, it serves ecological roles, providing food and habitat for wildlife."
            }

            else if detectedPlant == "anything but plants"{
                errorLabel.text = "Error. No Plant Detected"
                self.view.backgroundColor = UIColor.red
                commonName.text = ""
                scientificNameLabel.text = ""
                descriptionBox.text = ""
                presentErrorAlert()
            }
            
            
        }
        
        if let image = popupImage {
            popUpImage.layer.borderWidth = 4.0
            popUpImage.layer.borderColor = UIColor.black.cgColor
            popUpImage.image = image
            
        }
        
    }
}

