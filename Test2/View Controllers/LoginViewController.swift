//
//  LoginViewController.swift
//  Test2
//
//  Created by NASTUSYA on 2/17/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class LoginViewController: UIViewController {


    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setElementsUp()
        
    }
    
    @IBAction func loginTapped(_ sender: Any){
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    
    func setElementsUp(){
        errorLabel.alpha=0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleGreenButton(loginButton)
        Utilities.stylePurpleButton(signUpButton)
    }
    
    @objc fileprivate func uploadFhoto(){
        guard let image=imageView.image, let data=image.jpegData(compressionQuality: 1.0) else {
            
            print("Error uploading image")
            return
        }
        let imageReferance=Storage.storage().reference().child("images/rivers.jpg")
        
        imageReferance.putData(data, metadata: nil){
            (metadata,err) in
            if let error=err{
                print(error)
                return
            }
            imageReferance.downloadURL(completion: {(url,err) in
                if let error=err{
                    print(error)
                    return
                }
                
                guard let URL=url else{
                    print("problems")
                    return
                }
                
                print(URL)
            })
        }
    }
    

}
