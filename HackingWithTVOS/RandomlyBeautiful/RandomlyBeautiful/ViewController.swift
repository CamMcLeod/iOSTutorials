//
//  ViewController.swift
//  RandomlyBeautiful
//
//  Created by Cameron Mcleod on 2019-09-13.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categories = ["Airplanes", "Beaches", "Cats", "Cities", "Dogs", "Earth", "Forests", "Galexies", "Landmarks", "Mountains", "People", "Roads", "Sports", "Sunsets"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Images") as? ImagesViewController else { return }
    
        vc.category = categories[indexPath.row]
        present(vc, animated: true)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

