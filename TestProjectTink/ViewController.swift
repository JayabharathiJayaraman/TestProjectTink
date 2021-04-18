//
//  ViewController.swift
//  TestProjectTink
//
//  Created by Jayabharathi Jayaraman on 2021-04-13.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewFlowLayout : UICollectionViewFlowLayout!
    let cellIdentifier = "DogPicsCollectionViewCell"
    let enlargeDogPicSegue = "enlargeDogPicSegue"
    var imageUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpCollectionViewItemSize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("imageUrl\(imageUrl)")
        if segue.identifier == enlargeDogPicSegue{
            let vc = segue.destination as! DogImageViewerViewController
            vc.dogImageUrl = self.imageUrl
        }
    }
    
    func setUpCollectionViewItemSize(){
        if collectionViewFlowLayout == nil{
            let numberofItemPerRow : CGFloat = 2
            let minimumLineSpacing: CGFloat = 1
            let minimumInteritemSpacing: CGFloat = 1
            let width = (collectionView.frame.width - (numberofItemPerRow - 1) * minimumInteritemSpacing) / numberofItemPerRow
            let height = width
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = minimumLineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = minimumInteritemSpacing
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
            
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! DogPicsCollectionViewCell
        let jsonUrl = "https://dog.ceo/api/breeds/image/random/50"
        let url = URL(string: jsonUrl)
        URLSession.shared.dataTask(with: url!) { [self] (data, response, error ) in
            guard let data = data else{
                return
            }
            do{
                let dogImage = try JSONDecoder().decode(DogPics.self, from: data)
                imageUrl = dogImage.message[indexPath.row]
                print("dog:\(imageUrl)")
                cell.dogImageView.downloaded(from: imageUrl)
            }
            catch let jsonErr{
                print(jsonErr)
            }
        }.resume()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: enlargeDogPicSegue, sender: self)
    }
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

