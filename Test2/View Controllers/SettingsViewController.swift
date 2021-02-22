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
    
    @IBOutlet weak var darkSwitch: UISwitch!
    
    @IBAction func switchTapped(_ sender: Any) {
        if self.traitCollection.userInterfaceStyle == .light{
            view.window!.overrideUserInterfaceStyle = .dark
        }
        else{
            view.window!.overrideUserInterfaceStyle = .light
        }
        viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocalization()
        if self.traitCollection.userInterfaceStyle == .light{
            darkSwitch.setOn(false, animated: true)
        }
        else{
            darkSwitch.setOn(true, animated: true)
        }
    }
    
    /*override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                    //Dark
            }
            else {
                    //Light
            }
        }
        else {
            
        }
    }*/
    
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
