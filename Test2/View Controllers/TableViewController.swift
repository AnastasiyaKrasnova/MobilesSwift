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
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeChanged), name: UserDefaults.didChangeNotification, object: nil)
        
    }

    var data=Array<QueryDocumentSnapshot>()
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func settingsTapped(_ sender: Any) {
        
        let tableViewController = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.tableViewController) as? TableViewController)!
        let navViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationViewController) as? UINavigationController
        navViewController?.pushViewController(tableViewController, animated: true)
        view.window?.rootViewController = navViewController
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setDarkMode()
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
    
    @objc func themeChanged(){
        setDarkMode()
        let cells = self.tableView.visibleCells as! Array<CharacterTableViewCell>

            for cell in cells {
                cell.setLocalization()
                cell.setUpElements()
            }
    }
    
    func setDarkMode(){
        if (UserDefaults.standard.bool(forKey: CustomSettings.UserDefaultKeys.DARK.rawValue) == false){
            overrideUserInterfaceStyle = .light
        }
        else{
            overrideUserInterfaceStyle = .dark
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
        
        cell.setLocalization()
        cell.setUpElements()
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
    
    @IBOutlet weak var ageStaticLabel: UILabel!
    
    @IBOutlet weak var seasonStaticLabel: UILabel!
    
    public func setLocalization(){
        seasonStaticLabel.text=NSLocalizedString( "DetailedViewController_seasonStaticLabel", comment: "")
        ageStaticLabel.text=NSLocalizedString( "DetailedViewController_ageStaticLabel", comment: "")
    }
    
    public func setUpElements(){
        let color=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.COLOR.rawValue)!
        let font=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.STYLE.rawValue)!
        let size=UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
        Utilities.styleLabel(nameLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(standLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(ageLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(seasonLabel, colorName: color, fontName: font, fontSize: size)
    }
    
}




