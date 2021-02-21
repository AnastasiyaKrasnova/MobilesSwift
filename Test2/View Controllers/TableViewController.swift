//
//  TableViewController.swift
//  Test2
//
//  Created by NASTUSYA on 2/18/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseUI


class TableViewController: UIViewController{
    
    var data=Array<QueryDocumentSnapshot>()
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.alpha=1
        activityIndicator.startAnimating()
        
        loadCharacters(){(completion) in
            if completion==nil{
                print("Error loading characters")
            }
            else{
                self.data=completion!
                self.tableView.reloadData()
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.alpha=0
            }
                
        }
        tableView.delegate=self
        tableView.dataSource=self
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier==Constants.Storyboard.detailedSegue{
            if let indexPath=tableView.indexPathForSelectedRow{
                let destVC=segue.destination as! DetailedViewController
                destVC.data=data[indexPath.row]
            }
        }
        if segue.identifier==Constants.Storyboard.editorSegue{
                let destVC=segue.destination as! CharacterEditorViewController
                destVC.isEditing=false
                destVC.data=nil
        }
        if segue.identifier==Constants.Storyboard.mapSegue{
                let destVC=segue.destination as! MapsViewController
                destVC.data=data
        }
    }
}

extension TableViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected me")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteCharacter(data: data[indexPath.row])
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(data.count)
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.cellIdentifier, for: indexPath) as! CharacterTableViewCell
        cell.nameLabel?.text=data[indexPath.row].data()["name"] as? String
        cell.standLabel?.text=data[indexPath.row].data()["stand"] as? String
        cell.ageLabel?.text=data[indexPath.row].data()["age"] as? String
        cell.seasonLabel?.text=data[indexPath.row].data()["season"] as? String
        let url=data[indexPath.row].data()["avatar"] as? String
        downloadImage(url!, image: cell.avatarImageView)
        return cell
    }
}


class CharacterTableViewCell: UITableViewCell {

   
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var standLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var seasonLabel: UILabel!
    
   
    @IBOutlet weak var avatarImageView: UIImageView!
    
}



