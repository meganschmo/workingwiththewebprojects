//
//  ViewController.swift
//  DogNRep
//
//  Created by Megan Schmoyer on 12/1/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dogImageView: UIImageView!
    
    let dogImageController = DogImageController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func newImageButtonTapped(_ sender: Any) {
        dogImageView.image = nil
        Task {
            do {
                let dog = try await dogImageController.fetchDog()
                let imageData = try await dogImageController.fetchImage(for: dog.imageURL)
                dogImageView.image = UIImage(data: imageData)
            } catch {
                print("Error fetching dog image: \(error)")
                
            }
        }
        
    }
}
