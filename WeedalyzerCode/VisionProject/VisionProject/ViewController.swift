import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    var session: AVCaptureSession?
    
    let output = AVCapturePhotoOutput()
    
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    private var capturedImageView: UIImageView?
    
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private let boxView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        view.backgroundColor = UIColor.clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 30
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        view.addSubview(boxView) // Adding the box view
        checkCameraPermissions()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.size.width/2,
                                       y: view.frame.size.height - 200)
        // Set the frame for the boxView
        
        boxView.frame = CGRect(x: (view.frame.size.width - 300) / 2,
                               y: (view.frame.size.height - 650) / 2,
                               width: 300,
                               height: 450)
    }
    
    private func checkCameraPermissions(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        
        case.notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else{
                    return
                }
                DispatchQueue.main.async{
                    self.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    private func setUpCamera(){
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video){
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output) {
                    session.addOutput(output)
                    
                }
                
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            }
            catch{
                print(error)
            }
        }
    }
    
    @objc private func didTapTakePhoto(){
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }

}


extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
        if let image = UIImage(named: "example.jpg"){
            if let data = image.jpegData(compressionQuality: 0.8){
                let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
                try? data.write(to: filename)
            }
        }
        session?.stopRunning()
        
        // Display the captured photo
        
        
        
        // Keep the boxView visible
        

        
        // Optionally, you can save the captured image to your photo library
        // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    func uploadImage(imagepath: String){
        let image = UIImage(named: imagepath)
        let imageData = image?.jpegData(compressionQuality: 1)
        let fileURL = URL(fileURLWithPath: imagepath)
        let fileName = fileURL.lastPathComponent
        let fileContent = imageData?.base64EncodedString()
        let postData = fileContent!.data(using: .utf8)
        let APIKey = "NbbVN5cnQoPAAW8NBSNK"
        
        // Initialize Inference Server Request with API_KEY, Model, and Model Version
        var request = URLRequest(url: URL(string: "https://detect.roboflow.com/weed-identification-plxb0/5?api_key=\(APIKey)&name=\(fileName).jpg")!,timeoutInterval: Double.infinity)
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
            
            // Print String Response
            print(String(data: data, encoding: .utf8)!)
        }).resume()
    }
    
}







