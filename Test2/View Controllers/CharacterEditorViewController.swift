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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeChanged), name: UserDefaults.didChangeNotification, object: nil)
        
    }
    
    var inEditing: Bool!
    
    var photoChanged: Bool!
    
    var data: QueryDocumentSnapshot?
    
    var imagePicker = UIImagePickerController()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var standTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var seasonTextField: UITextField!
    
    @IBOutlet weak var xTextField: UITextField!
    
    @IBOutlet weak var yTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator.alpha=0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            avatarImageView.isUserInteractionEnabled = true
            avatarImageView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setLocalization()
        setElementsUp()
        photoChanged=false
        
        if data==nil{
            print("Error on segue")
        }
        else{
            nameTextField.text=data!.data()["name"] as? String
            standTextField.text=data!.data()["stand"] as? String
            ageTextField.text=data!.data()["age"] as? String
            seasonTextField.text=data!.data()["season"] as? String
            descriptionTextView.text=data!.data()["description"] as? String
            let x=data!.data()["latitude"] as? Double
            xTextField.text=String(format: "%.4f", x!)
            let y=data!.data()["longitude"] as? Double
            yTextField.text=String(format: "%.4f", y!)
            let url=data!.data()["avatar"] as? String
            downloadImage(url!, image: avatarImageView)
        }
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
        
        activityIndicator.alpha=1
        activityIndicator.startAnimating()
        
        let error=validateFields()
        if error==nil{
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let stand = standTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = ageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let season = seasonTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let desc = descriptionTextView.text!
            let x = Double(xTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let y = Double(yTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            if isEditing==false{
                addCharacter(name, stand: stand, age: age, season: season, desc: desc, x: x!, y: y!, images: Array<String?>(), videos: Array<String?>())
            }
            else{
                let avatar=data!.data()["avatar"] as! String
                let images=data!.data()["images"] as! Array<String?>?
                let videos=data!.data()["videos"] as! Array<String?>?
                editCharacter(name, stand: stand, age: age, season: season, desc: desc, x: x!, y: y!, avatar: avatar, images: images, videos: videos, documentID: data!.documentID)
            }
        }
        else{
            activityIndicator.alpha=0
            activityIndicator.stopAnimating()
            showError(error!, errorLabel: errorLabel)
        }
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.avatarImageView.image = image
                    self.photoChanged=true
                }
            })
    }
    
    
    func addCharacter(_ name: String,stand: String,age: String, season: String, desc: String, x: Double, y: Double, images: Array<String?>, videos: Array<String?>){
        let db = Firestore.firestore()
        
        uploadFhoto(avatarImageView){(completion) in
            if completion==nil{
                showError(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_avatarError", comment: ""), errorLabel: self.errorLabel)
                self.activityIndicator.alpha=0
                self.activityIndicator.stopAnimating()
            }
            else{
                let url=completion?.absoluteString
                db.collection("characters").addDocument(data: ["name":name, "avatar": url!,"stand":stand, "age": age, "season":season, "description": desc, "latitude":x,"longitude":y,"images": images, "videos": videos ]) { (error) in
                    
                    if error != nil {
                        showError(LocalizationSystem.sharedInstance.localizedStringForKey(key: "CharacterEditViewController_dataError", comment: ""), errorLabel: self.errorLabel)
                        self.activityIndicator.alpha=0
                        self.activityIndicator.stopAnimating()
                    }
                    else{
                        self.transitionToTable()
                    }
                }
            }
                
        }
        
    }
    
    
    func editCharacter(_ name: String,stand: String,age: String, season: String, desc: String, x: Double, y: Double,avatar: String, images: Array<String?>?, videos: Array<String?>?,documentID: String){
        
        if photoChanged{
            uploadFhoto(avatarImageView){(completion) in
                if completion==nil{
                    showError(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_avatarError", comment: ""), errorLabel: self.errorLabel)
                    self.activityIndicator.alpha=0
                    self.activityIndicator.stopAnimating()
                }
                else{
                    deleteDocument(avatar)
                    let new_avatar=completion?.absoluteString
                    self.updateCharacter(name, stand: stand, age: age, season: season, desc: desc, avatar: new_avatar!, x: x, y: y, documentID: documentID)
                }
                    
            }
        }
        else{
            self.updateCharacter(name, stand: stand, age: age, season: season, desc: desc, avatar: avatar, x: x, y: y, documentID: documentID)
        }
       
    }
    
    
    
    func updateCharacter(_ name: String,stand: String,age: String, season: String, desc: String, avatar: String, x: Double, y: Double, documentID: String){
        
        let db = Firestore.firestore()
        
        let washingtonRef = db.collection("characters").document(documentID)
        washingtonRef.updateData([
            "name":name,"stand":stand, "age": age, "season":season, "avatar": avatar, "description": desc, "latitude":x,"longitude":y
        ]) { [self] (error) in
            if error != nil {
                showError(LocalizationSystem.sharedInstance.localizedStringForKey(key:  "CharacterEditViewController_dataError", comment: ""), errorLabel: errorLabel)
                self.activityIndicator.alpha=0
                activityIndicator.stopAnimating()
            }
            else{
                self.transitionToTable()              }
        }
    }
    
    func validateFields()->String?{
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || standTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            seasonTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            xTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            yTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""
            {
                return LocalizationSystem.sharedInstance.localizedStringForKey(key:  "SignUpViewController_notFullError", comment: "")
            }
        
        let x = Double((xTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
        let y = Double((yTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
        if  (x == nil || x! < 0 || x! > 89.3) ||  (y == nil || y! < 0 || y! > 89.3){
            return LocalizationSystem.sharedInstance.localizedStringForKey(key:  "CharacterEditViewController_coordsNotDouble", comment: "")
        }
            return nil
    }

    
    func setLocalization(){
        nameTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CharacterEditorViewController_nameTextField", comment: "")
        standTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CharacterEditorViewController_standTextField", comment: "")
        ageTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CharacterEditorViewController_ageTextField", comment: "")
        seasonTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CharacterEditorViewController_seasonTextField", comment: "")
        xTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CharacterEditorViewController_xTextField", comment: "")
        yTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CharacterEditorViewController_yTextField", comment: "")
        saveButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "CharacterEditorViewController_saveButton", comment: ""), for: .normal)
    }
    
    func transitionToTable() {
        
        activityIndicator.alpha=0
        activityIndicator.stopAnimating()
        
        let tableViewController = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.tableViewController) as? TableViewController)!
        let navViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationViewController) as? UINavigationController
        navViewController?.pushViewController(tableViewController, animated: true)
        view.window?.rootViewController = navViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func setElementsUp(){
        errorLabel.alpha=0
        Utilities.styleTextField(nameTextField, colorName: "buttons_1")
        Utilities.styleTextField(seasonTextField, colorName: "buttons_1")
        Utilities.styleTextField(ageTextField, colorName: "buttons_1")
        Utilities.styleTextField(standTextField, colorName: "buttons_1")
        Utilities.styleTextField(xTextField, colorName: "buttons_1")
        Utilities.styleTextField(yTextField, colorName: "buttons_1")
        Utilities.styleButton(saveButton, colorName: "buttons_1")
        Utilities.styleImageView(avatarImageView, colorName: "buttons_1")
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
        LocalizationSystem.sharedInstance.setLanguage(languageCode:UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.LANG.rawValue)!)
        setLocalization()
        setElementsUp()
        
    }
    
}


    
