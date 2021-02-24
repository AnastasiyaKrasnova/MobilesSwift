//
//  DetailedViewController.swift
//  Test2
//
//  Created by NASTUSYA on 2/19/21.
//

import UIKit
import FirebaseFirestore

class DetailedViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeChanged), name: UserDefaults.didChangeNotification, object: nil)
        
    }

    @IBOutlet weak var nameStaticLabel: UILabel!
    @IBOutlet weak var ageStaticLabel: UILabel!
    @IBOutlet weak var seasonStaticLabel: UILabel!
    @IBOutlet weak var descriptionStaticLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var standLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    
    @IBOutlet weak var seasonLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var data: QueryDocumentSnapshot?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setLocalization()
        setElementsUp()
        
        if data==nil{
            print("Error on segue")
        }
        else{
            nameLabel.text=data!.data()["name"] as? String
            standLabel.text=data!.data()["stand"] as? String
            ageLabel.text=data!.data()["age"] as? String
            seasonLabel.text=data!.data()["season"] as? String
            descriptionTextView.text=data!.data()["description"] as? String
            
            let url=data!.data()["avatar"] as? String
            downloadImage(url!, image: avatarImageView)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier==Constants.Storyboard.editorSegue{
                let destVC=segue.destination as! CharacterEditorViewController
                destVC.isEditing=true
                destVC.data=data
        }
        if segue.identifier==Constants.Storyboard.photoSegue{
                let destVC=segue.destination as! CharacterPhotoViewController
            destVC.photos=data!.data()["images"] as? Array<String>
            destVC.videos=data!.data()["videos"] as? Array<String>
        }
        
    }
    
    func setLocalization(){
        nameStaticLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_standStaticLabel", comment: "")
        seasonStaticLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_seasonStaticLabel", comment: "")
        ageStaticLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_ageStaticLabel", comment: "")
        descriptionStaticLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_descriptionStaticLabel", comment: "")
    }
    
    public func setElementsUp(){
        //Utilities.styleImageView(avatarImageView, colorName: "buttons_2")
        Utilities.styleLabel(nameLabel, colorName: "buttons_1")
        Utilities.styleLabel(standLabel, colorName: "buttons_1")
        Utilities.styleLabel(ageLabel, colorName: "buttons_1")
        Utilities.styleLabel(seasonLabel, colorName: "buttons_1")
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



