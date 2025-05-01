//
//  CameraViewController.swift
//  carbonTracker
//
//  Created by Rishabh Rao on 30/04/25.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    var capturedImage: UIImage? // store image to pass

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
      self.capturedImage = image
      performSegue(withIdentifier: "showCrop", sender: image)
    }
  }
  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destination.
//         Pass the selected object to the new view controller.
      if segue.identifier == "showCrop",
         let cropVC = segue.destination as? CropViewController, let image = sender as? UIImage {
          cropVC.inputImage = self.capturedImage
      }
    }
    

}
