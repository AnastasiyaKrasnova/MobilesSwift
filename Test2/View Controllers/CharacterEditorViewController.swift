//
//  CharacterEditorViewController.swift
//  Test2
//
//  Created by NASTUSYA on 2/20/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class CharacterEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var inEditing: Bool!
    var imagePicker = UIImagePickerController()

    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var standTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var seasonTextField: UITextField!
    
    @IBOutlet weak var xTextField: UITextField!
    
    @IBOutlet weak var yTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    @IBAction func postTabbed(_ sender: Any) {
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let stand = standTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let age = ageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let season = seasonTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let x = xTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let y = yTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let desc = descriptionTextView.text!
        
        if isEditing==false{
            addCharacter(name, stand: stand, age: age, season: season, desc: desc, x: x, y: y)
        }
        else{
            editCharacter(name, stand: stand, age: age, season: season, desc: desc, x: x, y: y)
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.avatarImageView.image = image
                }
            })
    }
    
    
    func addCharacter(_ name: String,stand: String,age: String, season: String, desc: String, x: String, y: String){
        let db = Firestore.firestore()
        
        uploadFhoto(){(completion) in
            if completion==nil{
                self.showError("Error saving picture")
            }
            else{
                let url=completion?.absoluteString
                db.collection("characters").addDocument(data: ["name":name, "avatar": url!,"stand":stand, "age": age, "season":season, "description": desc, "x":x,"y":y ]) { (error) in
                    
                    if error != nil {
                        self.showError("Error saving user data")
                    }
                    else{
                        self.transitionToHome()
                    }
                }
            }
                
        }
        
    }
    
    
    func editCharacter(_ name: String,stand: String,age: String, season: String, desc: String, x: String, y: String){
        let db = Firestore.firestore()
        
        db.collection("characters").addDocument(data: ["name":name, "stand":stand, "age": age, "season":season, "description": desc, "x":x,"y":y ]) { (error) in
            
            if error != nil {
                self.showError("Error saving user data")
            }
        }
        
    }
    
    
    func showError(_ message:String){
        errorLabel.text=message
        errorLabel.alpha=1
    }
    
    
    func transitionToHome() {
    
        let tableViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tableViewController) as? TableViewController
        let navViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationViewController) as? UINavigationController
        
        navViewController!.setViewControllers([tableViewController!], animated: false)
        view.window?.rootViewController = navViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    @objc fileprivate func uploadFhoto(completion:  @escaping (URL?) -> Void){
        
        guard let image=avatarImageView.image, let data=image.jpegData(compressionQuality: 0.6) else {
            
            print("Error uploading image")
            completion(nil)
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
                completion(url)
            })
        }
    }
    
}


    
