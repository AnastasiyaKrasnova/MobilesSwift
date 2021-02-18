//
//  TableViewController.swift
//  Test2
//
//  Created by NASTUSYA on 2/18/21.
//

import UIKit
import Firebase
import FirebaseFirestore



class TableViewController: UIViewController{
    
    var data=Array<QueryDocumentSnapshot>()
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCharacters(){(completion) in
            if completion==nil{
                print("Error loading characters")
            }
            else{
                self.data=completion!
                self.tableView.reloadData()
            }
                
        }
        tableView.delegate=self
        tableView.dataSource=self
       
    }
    
    func loadCharacters(completion: @escaping (Array<QueryDocumentSnapshot>?) -> Void){

        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil)
            } else {
                completion(querySnapshot!.documents)
            }
        }

    }
}

extension TableViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected me")
    }
}

extension TableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(data.count)
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CharacterTableViewCell
        cell.firstNameLabel?.text=data[indexPath.row].data()["firstname"] as? String
        cell.lastNameLabel?.text=data[indexPath.row].data()["lastname"] as? String
        return cell
    }
    
}

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var characterImageView: UIImageView!
    
    
    
}


