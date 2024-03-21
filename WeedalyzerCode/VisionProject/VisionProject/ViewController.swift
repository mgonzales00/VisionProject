import UIKit
import Photos

class ViewController: UIViewController {
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraPreview: UIImageView!
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    @IBAction func tappedLibraryButton(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func uploadToRoboflow(_ sender: Any) {
        guard let image = cameraPreview.image else {
                print("No image to upload")
                return
            }
        uploadImage(image: image)
    }
    
}
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        if picker.sourceType == .camera {
            cameraPreview.image = image
            
            
        }
        else if self.imagePickerController.sourceType == .photoLibrary{
            cameraPreview.image = image
        }
    }
    
    func saveImageToImageFolder(image: UIImage){
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else{
            return
        }
        print(documentsDirectory.path)
        let imageFolderURL = documentsDirectory.appendingPathComponent("Images")
        
        do {
            try FileManager.default.createDirectory(at: imageFolderURL, withIntermediateDirectories: true,
                attributes: nil)
        }
        catch {
            print(error)
            return
        }
        
        let fileURL = imageFolderURL.appendingPathComponent("plant.jpeg")
        
        if let imageData = image.jpegData(compressionQuality: 1){
            do {
                try imageData.write(to: fileURL)
                print("Image saved")
            }
            catch{
                print(error)
            }
        }

    }
    func uploadImage(image: UIImage) {
        // Load image data from the file path
        
        // Convert the image to data
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            print("Failed to convert image to data")
            return
        }
        
        // Convert image data to base64 string
        let base64String = imageData.base64EncodedString()
        
        // Set up the request to Roboflow API
        let apiKey = "NbbVN5cnQoPAAW8NBSNK"
        let modelName = "weed-identification-plxb0/1"
        let urlString = "https://detect.roboflow.com/\(modelName)/api?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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

}
