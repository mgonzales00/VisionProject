import UIKit
import Photos

class ViewController: UIViewController{
    
    
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraPreview: UIImageView!
    
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
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus){
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("Access granted to use Photo Library")
        }
        else{
            print("We don't have access to your Photos.")
        }
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
        
        do{
            try FileManager.default.createDirectory(at: imageFolderURL, withIntermediateDirectories: true,
                attributes: nil)
        }
        catch{
            print(error)
            return
        }
        
        let fileURL = imageFolderURL.appendingPathComponent("plant.jpeg")
        
        if let imageData = image.jpegData(compressionQuality: 1){
            do{
                try imageData.write(to: fileURL)
                print("Image saved")
            }
            catch{
                print(error)
            }
        }
    }
}


