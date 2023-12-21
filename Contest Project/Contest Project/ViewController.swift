//
//  ViewController.swift
//  Contest Project
//
//  Created by Megan Schmoyer on 11/21/23.
//

import UIKit
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
class ViewController: UIViewController {
    @IBOutlet weak var thanksGivingMasImage: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        let circleImage = thanksGivingMasImage
        circleImage?.layer.cornerRadius = 20
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if let email = emailTextField.text, !email.isEmpty {
            performSegue(withIdentifier: "SubmitEntrySegue", sender: sender)
        } else {
            animatedTextField()
        }
    }   
    func animatedTextField() {
        // Shake animation for the text field
        let translation = CGAffineTransform(translationX: 10, y: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
            self.emailTextField.transform = translation
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                // Return the text field to its original state using the identity property
                self.emailTextField.transform = .identity
            }
        }
    }
}
