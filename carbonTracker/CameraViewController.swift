//
//  CameraViewController.swift
//  carbonTracker
//
//  Created by Rishabh Rao on 30/04/25.
//

import UIKit
import TOCropViewController

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
  
  var capturedImage: UIImage?
  var didTimeout = false

  override func viewDidLoad() {
    super.viewDidLoad()
    didTimeout = false
    print("🟢 CameraViewController loaded")
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func unwindToCamera(_ segue: UIStoryboardSegue) {
    // Optional: clean up state
  }
  
  @IBAction func takePhotoButtonTapped(_ sender: Any) {
    print("📸 Take Photo button tapped")
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
      print("Camera not available on this device.")
      return
    }
    print("📋 Currently presented view controller: \(String(describing: self.presentedViewController))")
    
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.delegate = self
    picker.allowsEditing = false
    present(picker, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
    picker.dismiss(animated: true)
    
    if let image = info[.originalImage] as? UIImage {
      // TODO: Navigate to CropViewController and pass the image
      print("📸 Image captured")
      let cropVC = TOCropViewController(image: image)
      cropVC.delegate = self
      cropVC.modalPresentationStyle = .fullScreen
      cropVC.modalTransitionStyle = .crossDissolve // or .crossDissolve, .flipHorizontal, .coverVertical etc.
      present(cropVC, animated: true)
      
    }
  }
  /*
   // MARK: - Cropping
   
   //
   */
  func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
    cropViewController.dismiss(animated: true) {
      
      
      LoadingOverlayView.shared.show(on: self.view, timeout: 5.0) {
          self.didTimeout = true  // Mark that a timeout occurred
          let alert = UIAlertController(title: "Timeout", message: "Text recognition is taking too long. Please try again.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          self.present(alert, animated: true)
      }
      // For testing purposes
//      DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 6.0) {
        OCRService.recognizeText(in: image) { [weak self] result in
          DispatchQueue.main.async {
            guard let self = self else { return }

            LoadingOverlayView.shared.hide()
            if self.didTimeout { return }

            guard let result = result,!result.isEmpty else {
              // Empty or nil result
              let alert = UIAlertController(title: "No Text Detected", message: "We couldn't detect any text in the image. Please try again.", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default))
              self.present(alert, animated: true)
              return
            }

            self.performSegue(withIdentifier: "showResultsSegue", sender: result)
          }
      }
  
//      }
    }
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   */
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showResultsSegue",
       let resultsVC = segue.destination as? ResultsViewController, let recognizedText = sender as? String {
      resultsVC.recognizedText = recognizedText
    }
  }
  
}
