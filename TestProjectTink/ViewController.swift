//
//  ViewController.swift
//  TestProjectTink
//
//  Created by Jayabharathi Jayaraman on 2021-04-13.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getDogPics()
    }
    
    func getDogPics(){
        let jsonUrl = "https://dog.ceo/api/breeds/image/random/50"
        guard let url = URL(string: jsonUrl) else
        { return }
        URLSession.shared.dataTask(with: url) { (data, response, error ) in
            guard let data = data else{
                return
            }
            do{
                let course = try JSONDecoder().decode(DogPics.self, from: data)
                for index in 0...49{
                    let dogUrl = course.message[index]
                    print(dogUrl)
                    let imageUrl = URL(string: dogUrl)
                    self.imageView.downloaded(from: imageUrl!)
                }
                
            } catch let jsonErr{
                print(jsonErr)
            }
            
        }.resume()
        
    }
}

struct DogPics: Codable {
    let message: [String]
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
