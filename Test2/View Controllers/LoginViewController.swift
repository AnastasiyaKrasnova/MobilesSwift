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
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setElementsUp()
        setLocalization()
    }
    
    @IBAction func loginTapped(_ sender: Any){
        uploadVideo()
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                showError(LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_loginError", comment: ""), errorLabel: self.errorLabel)
                
            }
            else {
                self.transitionToTable()
            }
        }
    }
    
    
    func setElementsUp(){
        errorLabel.alpha=0
        Utilities.styleTextField(emailTextField, colorName: "buttons_1")
        Utilities.styleTextField(passwordTextField, colorName: "buttons_1")
        Utilities.styleButton(loginButton, colorName: "buttons_1")
        Utilities.styleButton(signUpButton, colorName: "buttons_2")
    }
    
    
    func setLocalization(){
        emailTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_emailTextField", comment: "")
        passwordTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_passwordTextField", comment: "")
        loginButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_loginButton", comment: ""), for: .normal)
        signUpButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_signUpButton", comment: ""), for: .normal)
    }
    
    func transitionToTable() {
        
        let tableViewController = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.tableViewController) as? TableViewController)!
        let loginViewController = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController)!
        let navViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationViewController) as? UINavigationController
        navViewController?.pushViewController(loginViewController, animated: true)
        navViewController?.pushViewController(tableViewController, animated: true)
        view.window?.rootViewController = navViewController
        view.window?.makeKeyAndVisible()
        
    }
    

}
