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

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeChanged), name: UserDefaults.didChangeNotification, object: nil)
        
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkMode()
        setLocalization()
        setElementsUp()
    }
    
    @IBAction func loginTapped(_ sender: Any){
        uploadVideo()
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                showError(NSLocalizedString("LoginViewController_loginError", comment: ""), errorLabel: self.errorLabel)
            }
            else {
                self.transitionToTable()
            }
        }
    }
    
    
    func setElementsUp(){
        errorLabel.alpha=0
        let color=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.COLOR.rawValue)!
        let font=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.STYLE.rawValue)!
        let size=UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
        Utilities.styleButton(loginButton, colorName: color, fontName: font, fontSize: size)
        Utilities.styleButton(signUpButton, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(emailTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(passwordTextField, colorName: color, fontName: font, fontSize: size)
    }
    
    
    func setLocalization(){
        loginButton.setTitle(NSLocalizedString("LoginViewController_loginButton", comment: ""), for: .normal)
        signUpButton.setTitle(NSLocalizedString("LoginViewController_signUpButton", comment: ""), for: .normal)
        emailTextField.placeholder=NSLocalizedString("LoginViewController_emailTextField", comment: "")
        passwordTextField.placeholder=NSLocalizedString("LoginViewController_passwordTextField", comment: "")
        
    }
    
    func transitionToTable() {
        
        let tableViewController = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.tableViewController) as? TableViewController)!
        let navViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationViewController) as? UINavigationController
        navViewController?.pushViewController(tableViewController, animated: true)
        view.window?.rootViewController = navViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func setDarkMode(){
        if (UserDefaults.standard.bool(forKey: CustomSettings.UserDefaultKeys.DARK.rawValue) == false){
            overrideUserInterfaceStyle = .light
        }
        else{
            overrideUserInterfaceStyle = .dark
        }
    }
    
    @objc func themeChanged(){
        setDarkMode()
        setLocalization()
        setElementsUp()
        
    }
    

}
