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
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
      present(cropVC, animated: true)
      
    }
  }
  
  func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
    cropViewController.dismiss(animated: true) {
      
      
      let spinner = UIActivityIndicatorView(style: .large)
      spinner.center = self.view.center
      self.view.addSubview(spinner)
      spinner.startAnimating()
      
      OCRService.recognizeText(in: image) { [weak self] result in
        DispatchQueue.main.async {
          spinner.stopAnimating()
          spinner.removeFromSuperview()
          
          self?.performSegue(withIdentifier: "showResultsSegue", sender: result)
        }
      }
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
