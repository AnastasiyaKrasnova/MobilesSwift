//
//  DetailedViewController.swift
//  Test2
//
//  Created by NASTUSYA on 2/19/21.
//

import UIKit
import FirebaseFirestore

class DetailedViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var standLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    
    @IBOutlet weak var seasonLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var data: QueryDocumentSnapshot?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            avatarImageView.isUserInteractionEnabled = true
            avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
       transitionToCollection()
    }
    
    func transitionToCollection() {
        
        let characterPhotoViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.characterPhotoViewController) as? CharacterPhotoViewController
        
        view.window?.rootViewController = characterPhotoViewController
        view.window?.makeKeyAndVisible()
        
    }

}



