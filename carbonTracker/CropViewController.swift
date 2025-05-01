//
//  CropViewController.swift
//  carbonTracker
//
//  Created by Rishabh Rao on 30/04/25.
//

import UIKit

class CropViewController: UIViewController {
  var inputImage: UIImage? // image passed from camera
  var croppedResult: UIImage?
  var activityIndicator: UIActivityIndicatorView!
  var recognizedTextResult: String?
  
  @IBOutlet weak var bottomRightHandle: UIButton!
  @IBOutlet weak var cropRectView: UIView!
  @IBOutlet weak var topLeftHandle: UIButton!
  @IBOutlet weak var bottomLeftHandle: UIButton!
  @IBOutlet weak var topRightHandle: UIButton!
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("🟡 CropViewController loaded")
    navigationItem.hidesBackButton = true
    
    activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.center = view.center
    activityIndicator.hidesWhenStopped = true
    view.addSubview(activityIndicator)
    
    /*
     // Position handles at corners of cropRectView
     topLeftHandle.center = CGPoint(x: cropRectView.frame.minX, y: cropRectView.frame.minY)
     topRightHandle.center = CGPoint(x: cropRectView.frame.maxX, y: cropRectView.frame.minY)
     bottomLeftHandle.center = CGPoint(x: cropRectView.frame.minX, y: cropRectView.frame.maxY)
     bottomRightHandle.center = CGPoint(x: cropRectView.frame.maxX, y: cropRectView.frame.maxY)
     
     let handles = [topLeftHandle, topRightHandle, bottomLeftHandle, bottomRightHandle]
     for handle in handles {
     handle?.layer.cornerRadius = handle!.frame.width / 2
     handle?.backgroundColor = .white
     handle?.layer.borderWidth = 1
     handle?.layer.borderColor = UIColor.black.cgColor
     
     handle?.layer.shadowColor = UIColor.gray.cgColor
     handle?.layer.shadowOpacity = 0.7
     handle?.layer.shadowOffset = CGSize(width: 0, height: 1)
     handle?.layer.shadowRadius = 2
     }
     */
    
    if let image = inputImage {
      imageView.image = image
    }
    
    /*
     let panGestureTL = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
     topLeftHandle.addGestureRecognizer(panGestureTL)
     topLeftHandle.isUserInteractionEnabled = true
     
     let panGestureTR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
     topRightHandle.addGestureRecognizer(panGestureTR)
     topRightHandle.isUserInteractionEnabled = true
     
     let panGestureBL = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
     bottomLeftHandle.addGestureRecognizer(panGestureBL)
     bottomLeftHandle.isUserInteractionEnabled = true
     
     let panGestureBR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
     bottomRightHandle.addGestureRecognizer(panGestureBR)
     bottomRightHandle.isUserInteractionEnabled = true
     */
  }
  
  @IBAction func cropImageTapped(_ sender: Any) {
    guard let image = imageView.image else { return }
    
    // Adding processing loader
    activityIndicator.startAnimating()
    view.isUserInteractionEnabled = false // Prevent further interaction
    
    // 🚫 Skipping cropping — directly sending original image
    self.croppedResult = image
    
    // Skip cropping for now, send full image
    OCRService.recognizeText(in: image) { [weak self] recognizedText in
      DispatchQueue.main.async {
        self?.activityIndicator.stopAnimating()
        self?.view.isUserInteractionEnabled = true
        
        self?.recognizedTextResult = recognizedText
        self?.croppedResult = image // Use full image for now
        self?.performSegue(withIdentifier: "showResultsSegue", sender: self)
      }
    }
    
    /*
     let scale = image.size.width / imageView.frame.width
     let cropRect = cropRectView.frame.applying(CGAffineTransform(scaleX: scale, y: scale))
     
     if let croppedCGImage = image.cgImage?.cropping(to: cropRect) {
     let croppedImage = UIImage(cgImage: croppedCGImage)
     
     self.croppedResult = croppedImage
     performSegue(withIdentifier: "showResultsSegue", sender: self)
     }
     */
  }
  
  /*
   @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
   guard let handle = gesture.view else { return }
   let translation = gesture.translation(in: cropRectView.superview)
   
   handle.center = CGPoint(x: handle.center.x + translation.x, y: handle.center.y + translation.y)
   gesture.setTranslation(.zero, in: cropRectView.superview)
   
   updateCropRect()
   }
   
   func updateCropRect() {
   let x = min(topLeftHandle.center.x, bottomLeftHandle.center.x)
   let y = min(topLeftHandle.center.y, topRightHandle.center.y)
   let width = abs(topRightHandle.center.x - topLeftHandle.center.x)
   let height = abs(bottomLeftHandle.center.y - topLeftHandle.center.y)
   
   cropRectView.frame = CGRect(x: x, y: y, width: width, height: height)
   }
   */
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showResultsSegue" {
      if let destVC = segue.destination as? ResultsViewController {
        destVC.recognizedText = self.recognizedTextResult
      }
    }
  }
  
  
}
