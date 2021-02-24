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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    
    @IBAction func tapped(_ sender: UIBarButtonItem) {
        print("Hello")
    }
    
    
    var data: QueryDocumentSnapshot?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDarkMode()
        setLocalization()
        setElementsUp()
        
        activityIndicator.alpha=0
        
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
        nameStaticLabel.text=NSLocalizedString( "DetailedViewController_standStaticLabel", comment: "")
        seasonStaticLabel.text=NSLocalizedString( "DetailedViewController_seasonStaticLabel", comment: "")
        ageStaticLabel.text=NSLocalizedString( "DetailedViewController_ageStaticLabel", comment: "")
        descriptionStaticLabel.text=NSLocalizedString("DetailedViewController_descriptionStaticLabel", comment: "")
    }
    
    public func setElementsUp(){
        let color=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.COLOR.rawValue)!
        let font=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.STYLE.rawValue)!
        let size=UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
        Utilities.styleLabel(nameLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(standLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(ageLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(seasonLabel, colorName: color, fontName: font, fontSize: size)
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



