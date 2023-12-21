//
//  SecondViewController.swift
//  Contest Project
//
//  Created by Megan Schmoyer on 11/23/23.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        // Define the colors for the gradient
        let color1 = UIColor(hex: "B56539").cgColor
        let color2 = UIColor(hex: "B54448").cgColor
        let color3 = UIColor(hex: "B54448").cgColor
        gradientLayer.colors = [color1, color2, color3]
        
        // Set the direction of the gradient
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        // Add the gradient layer to your view's layer
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [color1, color2, color3]
        animation.toValue = [color3, color2, color1]
        animation.autoreverses = true
        animation.duration = 1.5
        animation.repeatCount = Float.infinity
        
        // Add the animation to the gradient layer
        gradientLayer.add(animation, forKey: "gradientAnimation")
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
