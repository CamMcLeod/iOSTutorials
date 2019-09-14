//
//  ImagesViewController.swift
//  RandomlyBeautiful
//
//  Created by Cameron Mcleod on 2019-09-13.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var creditLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    
    var category = ""
    var appID = "9862eefff39bf8427ebf42d2811baece5c9a0fade32dfd5a3013dd28dec910e3"
    var images = [JSON]()
    var imageViews = [UIImageView]()
    var imageCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageViews = view.subviews.compactMap {$0 as? UIImageView}
        imageViews.forEach { $0.alpha = 0 }
        creditLabel.layer.cornerRadius = 15
        profileImageView.layer.cornerRadius = 15
        
        guard let url = URL(string: "https://api.unsplash.com/search/photos?client_id=\(appID)&query=\(category)&per_page=100") else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetch(url)
        }
    }

    func fetch(_ url: URL) {
        
        if let data = try? Data(contentsOf: url) {
            
            let json = JSON(data)
            images = json["results"].arrayValue
            downloadImage()
            
        }
        
    }
    
    func downloadImage() {
        
        let currentImage = images[imageCounter % images.count]
        
        let imageName = currentImage["urls"]["full"].stringValue
        let imageCredit = currentImage["user"]["name"].stringValue
        let profileURL = currentImage["user"]["profile_image"]["large"].stringValue
        
        imageCounter += 1
        
        guard let imageURL = URL(string: imageName) else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        guard let image = UIImage(data: imageData) else { return }
        
        guard let profileImageURL = URL(string: profileURL) else { return }
        guard let profileImageData = try? Data(contentsOf: profileImageURL) else { return }
        guard let profileImage = UIImage(data: profileImageData) else { return }
        
        DispatchQueue.main.async {
            
            self.show(image, profileImage: profileImage, credit: imageCredit)
        }
        
    }
    
    func show(_ image: UIImage, profileImage: UIImage, credit: String) {
        spinner.stopAnimating()
        
        let imageViewToUse = imageViews[imageCounter % imageViews.count]
        let otherImageView = imageViews[(imageCounter + 1 ) % imageViews.count]
        
        
        UIView.animate(withDuration: 2.0, animations: {
            
            imageViewToUse.image = image
            imageViewToUse.alpha = 1
            
            self.creditLabel.alpha = 0
            self.profileImageView.alpha = 0
            self.view.sendSubviewToBack(otherImageView)
            
        }) { _ in
            
            // crossfade finish
            self.creditLabel.text = "   \(credit.uppercased())"
            self.profileImageView.image = profileImage
            UIView.animate(withDuration: 2.0, animations: {
                self.creditLabel.alpha = 0.8
                self.profileImageView.alpha = 0.8
            })
            otherImageView.alpha = 0
            otherImageView.transform = .identity
            
            UIView.animate(withDuration: 10.0, animations: {
                imageViewToUse.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
            }, completion: { _ in
                DispatchQueue.global(qos: .userInteractive).async {
                    self.downloadImage()
                }
            })
        }
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
