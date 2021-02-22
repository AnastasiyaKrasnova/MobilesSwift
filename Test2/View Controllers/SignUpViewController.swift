//
//  SignUpViewController.swift
//  Test2
//
//  Created by NASTUSYA on 2/17/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
   
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setElementsUp()
        setLocalization()
    }
    
    func validateFields()->String?{
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""
        {
            return "Please fill all the text fields"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword)==false{
            return "Your password is not strong enough"
        }
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    self.showError("Error creating user")
                }
                else {
                    
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "email": email, "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    // Transition to the home screen
                    self.transitionToHome()
                }
                
            }
        
        }
    }
    
    func showError(_ message:String){
        errorLabel.text=message
        errorLabel.alpha=1
    }
    
    func setElementsUp(){
        errorLabel.alpha=0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.stylePurpleButton(signUpButton)
    }
    
    
    func transitionToHome() {
        
        let loginViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func setLocalization(){
        emailTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_emailTextField", comment: "")
        passwordTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_passwordTextField", comment: "")
        firstNameTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_firstNameTextField", comment: "")
        lastNameTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_lastNameTextField", comment: "")
        signUpButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_signUpButton", comment: ""), for: .normal)
    }

}
