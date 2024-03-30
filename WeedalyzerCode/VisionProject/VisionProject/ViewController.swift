import UIKit
import Vision
import Photos
import CoreML

class ViewController: UIViewController {
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraPreview: UIImageView!
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    var imagePickerController = UIImagePickerController()
    lazy var detectionRequest: VNCoreMLRequest = {
        do {
                    let model = try VNCoreMLModel(for: MyImageClassifier_2().model)
                    let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                        self?.processDetections(for: request, error: error)
                    })
                    request.imageCropAndScaleOption = .scaleFit
                    return request
                } catch {
                    fatalError("Failed to load Vision ML model: \(error)")
                }
}()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self // Set the delegate for UIImagePickerController
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else{
            return
        }
        print(documentsDirectory.path)
    }
    
    @IBAction func tappedCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
        let cb = UIImagePickerController()
        cb.sourceType = .camera
        cb.delegate = self
        present(cb, animated: true)
    }
    
    @IBAction func tappedLibraryButton(_ sender: UIButton) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func uploadToRoboflow(_ sender: Any) {
        guard let image = cameraPreview.image else {
            print("No image to upload")
            return
        }
        if let imageURL = saveImageToImageFolder(image: image) {
            uploadImageToRoboflow(imageURL: imageURL)
        } else {
            print("Failed to save image to file")
        }
        
    }
    
}



extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private func updateDetections(for image: UIImage) {
       
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
                
                DispatchQueue.global(qos: .userInitiated).async {
                    let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation!)
                    do {
                        try handler.perform([self.detectionRequest])
                    } catch {
                        print("Failed to perform classification.\n\(error.localizedDescription)")
                    }
                }
            }
            
    private func processDetections(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            
            if let topResult = results.first as? VNClassificationObservation {
                // Handle the classification result here
                print("Top result: \(topResult.identifier), confidence: \(topResult.confidence)")
                // You can update UI or perform any other action based on the classification result
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        self.cameraPreview?.image = image
        updateDetections(for: image)
        if picker.sourceType == .camera {
            cameraPreview.image = image
            
        }
        else if self.imagePickerController.sourceType == .photoLibrary{
            cameraPreview.image = image
        }
    }
    
    func saveImageToImageFolder(image: UIImage) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else{
            return nil
        }
        
        do {
            try FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true,
                                                    attributes: nil)
        }
        catch {
            print(error)
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("plant.jpeg")
        
        if let imageData = image.jpegData(compressionQuality: 0.3){
            do {
                try imageData.write(to: fileURL)
                print("Image saved")
                return fileURL
            }
            catch{
                print(error)
                return nil
            }
        }
        return nil
    }
    
    func uploadImageToRoboflow(imageURL: URL) {
        // Convert the image to data
        guard let imageData = try? Data(contentsOf: imageURL) else {
            print("Failed to convert image to data")
            return
        }
        
        // Convert image data to base64 string
        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        
        // Set up the request to Roboflow API
        let APIKey = "NbbVN5cnQoPAAW8NBSNK"
        let fileName = "plant.jpeg" // Update with your desired file name
        let urlString = "https://detect.roboflow.com/weed-identification-plxb0/1?api_key=\(APIKey)&name=\(fileName)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Construct the request body
        let requestBody: [String: Any] = [
            "image": base64String
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        // debug print full request
        //print("\(request.httpMethod!) \(request.url!)")
        //print(request.allHTTPHeaderFields!)
        //print(String(data: request.httpBody ?? Data(), encoding: .utf8)!)
        
        // Send the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            
            if let data = data,
               let responseString = String(data: data, encoding: .utf8) {
                print("Upload response: \(responseString)")
                // Handle response from Roboflow
            }
        }.resume()
        

    }

    func uploadImageToVision(imagepath: String) {

        let APIKey = "AIzaSyBa8AdmhzcLtdKfECm4PwKzomdYoPGh8lc"

    }
    
}
