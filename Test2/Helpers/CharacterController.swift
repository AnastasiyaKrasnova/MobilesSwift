//
//  CharacterController.swift
//  Test2
//
//  Created by NASTUSYA on 2/20/21.
//

import Foundation
import Firebase
import FirebaseStorage

func loadCharacters(completion: @escaping (Array<QueryDocumentSnapshot>?) -> Void){

    let db = Firestore.firestore()
    db.collection("characters").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
            completion(nil)
        } else {
            completion(querySnapshot!.documents)
        }
    }
}

func deleteCharacter(data: QueryDocumentSnapshot){
    let db = Firestore.firestore()
    db.collection("characters").document(data.documentID).delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
        } else {
            print("Document successfully removed!")
        }
    }
    deleteDocument(data.data()["avatar"] as! String)
    
}

func downloadImage(_ ref: String, image: UIImageView){
    let reference = Storage.storage().reference(forURL: ref)

    let placeholderImage = UIImage(named: "placeholder.jpg")

    image.sd_setImage(with: reference, placeholderImage: placeholderImage)
   
}

func uploadFhoto(_ imageView: UIImageView, completion:  @escaping (URL?) -> Void){
    
    guard let image=imageView.image, let data=image.jpegData(compressionQuality: 0.6) else {
        
        print("Error uploading image")
        completion(nil)
        return
    }
    let imageReferance=Storage.storage().reference().child("images/"+NSUUID().uuidString)
    
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

func deleteDocument(_ ref: String){
    let reference = Storage.storage().reference(forURL: ref)
    reference.delete { error in
      if let error = error {
        print(error)
      } else {
        print("Deleted")
      }
    }
}

func uploadVideo(){
    let localFile = URL(string: "/Users/nastusya/Desktop/PicturesForMobiles/videoplayback.mp4")!

    let videoReferance=Storage.storage().reference().child("images/videoplayback.mp4")
    /*let uploadTask = videoReferance.putFile(from: localFile, metadata: nil) { metadata, error in
      guard let metadata = metadata else {
        print("Error with metadata")
        return
      }*/
        videoReferance.downloadURL { (url, error) in
        guard let downloadURL = url else {
            print("Error with url")
            return
        }
        print(downloadURL)
      }
}

func showError(_ message:String, errorLabel: UILabel){
    errorLabel.text=message
    errorLabel.alpha=1
}
