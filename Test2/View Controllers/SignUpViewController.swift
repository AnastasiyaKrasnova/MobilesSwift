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

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeChanged), name: UserDefaults.didChangeNotification, object: nil)
        
    }
    
   
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var imagePicker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDarkMode()
        setElementsUp()
        setLocalization()
        
        activityIndicator.alpha=0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            avatarImageView.isUserInteractionEnabled = true
            avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    imagePicker.delegate = self
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false

                    present(imagePicker, animated: true, completion: nil)
                }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.avatarImageView.image = image
                }
            })
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        activityIndicator.alpha=1
        activityIndicator.startAnimating()
        
        let error = validateFields()
        
        if error != nil {
            activityIndicator.alpha=0
            activityIndicator.stopAnimating()
            showError(error!, errorLabel: errorLabel)
        }
        else {
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    showError(NSLocalizedString( "SignUpViewController_authError", comment: ""), errorLabel: self.errorLabel)
                    self.activityIndicator.alpha=0
                    self.activityIndicator.stopAnimating()
                }
                else {
                    
                    uploadFhoto(self.avatarImageView){ [self](completion) in
                        if completion==nil{
                            showError(NSLocalizedString( "SignUpViewController_authError", comment: ""), errorLabel: self.errorLabel)
                            self.activityIndicator.alpha=0
                            self.activityIndicator.stopAnimating()
                        }
                        else{
                            
                            let url=completion?.absoluteString
                            let db = Firestore.firestore()
                    
                            db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "email": email, "avatar": url!, "uid": result!.user.uid ]) { [self] (error) in
                        
                                if error != nil {
                                    showError(NSLocalizedString( "SignUpViewController_dataError", comment: ""), errorLabel: self.errorLabel)
                                    self.activityIndicator.alpha=0
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                            self.transitionToHome()
                        }
                    }
                
            }
        }
    }
}
    
    
    func setElementsUp(){
        errorLabel.alpha=0
        let color=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.COLOR.rawValue)!
        let font=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.STYLE.rawValue)!
        let size=UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
        Utilities.styleTextField(emailTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(passwordTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(firstNameTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(lastNameTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleButton(signUpButton, colorName: color, fontName: font, fontSize: size)
        Utilities.styleImageView(avatarImageView, colorName: color)
    }
    
    
    func transitionToHome() {
        
        activityIndicator.alpha=0
        activityIndicator.stopAnimating()
        
        let loginViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func setLocalization(){
        emailTextField.placeholder=NSLocalizedString("LoginViewController_emailTextField", comment: "")
        passwordTextField.placeholder=NSLocalizedString("LoginViewController_passwordTextField", comment: "")
        firstNameTextField.placeholder=NSLocalizedString("LoginViewController_firstNameTextField", comment: "")
        lastNameTextField.placeholder=NSLocalizedString("LoginViewController_lastNameTextField", comment: "")
        signUpButton.setTitle(NSLocalizedString( "LoginViewController_signUpButton", comment: ""), for: .normal)
    }
    
    func validateFields()->String?{
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""
        {
            return NSLocalizedString( "SignUpViewController_notFullError", comment: "")
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword)==false{
            return NSLocalizedString( "SignUpViewController_sickPasswordError", comment: "")
        }
        return nil
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
