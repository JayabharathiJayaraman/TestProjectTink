//
//  DogImageViewerViewController.swift
//  TestProjectTink
//
//  Created by Jayabharathi Jayaraman on 2021-04-16.
//

import UIKit

class DogImageViewerViewController: UIViewController {
    
    @IBOutlet weak var pugTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dogDescriptionTextField: UITextView!
    public var dogImageUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("dogImageUrl\(dogImageUrl)")
        self.imageView.downloaded(from: dogImageUrl)
        pugTitleLabel.font = UIFont.boldSystemFont(ofSize: 28.0)
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
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
