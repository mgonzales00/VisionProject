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
        let image = UIImage(data:data)
        session?.stopRunning()

        // Display the captured photo
        let capturedImageView = UIImageView(image: image)
        capturedImageView.contentMode = .scaleAspectFill
        capturedImageView.frame = view.bounds
        view.addSubview(capturedImageView)

        // Create an overlay view for the area above the boxView
        let topOverlayView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: boxView.frame.minY))
        let topMaskLayer = CAShapeLayer()
        topMaskLayer.path = UIBezierPath(roundedRect: topOverlayView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath
        topOverlayView.layer.mask = topMaskLayer
        topOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(topOverlayView)

        // Create an overlay view for the area below the boxView
        let bottomOverlayView = UIView(frame: CGRect(x: 0, y: boxView.frame.maxY, width: view.bounds.width, height: view.bounds.height - boxView.frame.maxY))
        let bottomMaskLayer = CAShapeLayer()
        bottomMaskLayer.path = UIBezierPath(roundedRect: bottomOverlayView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath
        bottomOverlayView.layer.mask = bottomMaskLayer
        bottomOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(bottomOverlayView)

        // Create an overlay view for the area to the left of the boxView
        let leftOverlayView = UIView(frame: CGRect(x: 0, y: boxView.frame.minY, width: boxView.frame.minX, height: boxView.frame.height))
        leftOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(leftOverlayView)

        // Create an overlay view for the area to the right of the boxView
        let rightOverlayView = UIView(frame: CGRect(x: boxView.frame.maxX, y: boxView.frame.minY, width: view.bounds.width - boxView.frame.maxX, height: boxView.frame.height))
        rightOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(rightOverlayView)

        // Keep the boxView visible
        view.bringSubviewToFront(boxView)

        // Optionally, you can save the captured image to your photo library
        // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}







