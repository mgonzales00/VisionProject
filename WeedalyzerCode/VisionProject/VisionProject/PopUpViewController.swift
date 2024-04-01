//
//  PopUpViewController.swift
//  VisionProject
//
//  Created by Griffin Freudenberg on 3/30/24.
//

import UIKit

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var detectionResultLabel: UILabel!
    var detectedPlant: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let detectedPlant = detectedPlant {
            detectionResultLabel.text = detectedPlant        }
        // Do any additional setup after loading the view.
    }
    
    
    
}

