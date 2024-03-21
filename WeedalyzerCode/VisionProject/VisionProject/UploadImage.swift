//
//  UploadImage.swift
//  VisionProject
//
//  Created by Max on 2/22/24.
//

import Foundation
import UIKit

func uploadImageToRoboflow(imagepath: String) -> String {
    // Load Image and Convert to Base64
    let image = UIImage(named: imagepath) // path to image to upload ex: image.jpg
    let imageData = image?.jpegData(compressionQuality: 1)
    let fileURL = URL(fileURLWithPath: imagepath)
    let fileName = fileURL.lastPathComponent
    let fileContent = imageData?.base64EncodedString()
    let postData = fileContent!.data(using: .utf8)
    let APIKey = "NbbVN5cnQoPAAW8NBSNK"
    var responseString: String = ""

    // Initialize Inference Server Request with API_KEY, Model, and Model Version
    var request = URLRequest(url: URL(string: "https://detect.roboflow.com/weed-identification-plxb0/1?api_key=\(APIKey)&name=\(fileName).jpg")!,timeoutInterval: Double.infinity)
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = postData

    // Execute Post Request
    URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
        
        // Parse Response to String
        guard let data = data else {
            print(String(describing: error))
            return
        }
        
        // Convert Response String to Dictionary
        do {
            let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        
        if let string = String(data: data, encoding: .utf8) {
            responseString = string
        } else {
            responseString = "Error converting data to string"
        }
    }).resume()

    return responseString;
}

func uploadImageToVision(imagepath: String) -> String {
    var responseString: String = ""
    return responseString;
}
