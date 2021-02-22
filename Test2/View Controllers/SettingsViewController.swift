//
//  SettingsViewController.swift
//  Test2
//
//  Created by NASTUSYA on 2/22/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var langLabel: UILabel!
    
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var darkModeLabel: UILabel!
    
    @IBOutlet weak var changeLanguageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
       
    }
    
    @IBAction func changeLangTapped(_ sender: Any) {
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ru")
        } else {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
        }
        viewDidLoad()
                
    }
    
    func setLocalization(){
        titleLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_titleLabel", comment: "")
        langLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_langLabel", comment: "")
        colorLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_colorLabel", comment: "")
        darkModeLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_darkModeLabel", comment: "")
        changeLanguageButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_changeLanguageButton", comment: ""), for: .normal)
    }
}
