//
//  ResultsViewController.swift
//  carbonTracker
//
//  Created by Rishabh Rao on 30/04/25.
//

import UIKit

class ResultsViewController: UIViewController {
  var recognizedText: String?

  @IBOutlet weak var textView: UILabel!
  override func viewDidLoad() {
      super.viewDidLoad()
 
      textView.text = recognizedText ?? "No text found"

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
