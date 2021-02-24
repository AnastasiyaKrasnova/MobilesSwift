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
    
    @IBOutlet weak var languagePicker: UIPickerView!
    
    @IBOutlet weak var colorThemeButton: UIButton!
    
    @IBOutlet weak var colorPickerView: UIPickerView!
    
    @IBAction func colorChangedTapped(_ sender: Any) {
    }
    
    var languages : Array<String>?
    var languagesCodes = ["en", "ru"]
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        setLocalization()
        //setUpElements()
        languagePicker.isHidden=true
        if self.traitCollection.userInterfaceStyle == .light{
            darkSwitch.setOn(false, animated: true)
        }
        else{
            darkSwitch.setOn(true, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languagePicker.delegate=self
        languagePicker.dataSource=self
        /*NotificationCenter.default.addObserver(self, selector: #selector(self.themeChanged), name: UserDefaults.didChangeNotification, object: nil)*/
    }
    
   
    
    @IBAction func switchTapped(_ sender: Any) {
       /* if self.traitCollection.userInterfaceStyle == .light{
            view.window!.overrideUserInterfaceStyle = .dark
        }
        else{
            view.window!.overrideUserInterfaceStyle = .light
        }*/
        /*if (UserDefaults.standard.bool(forKey: UserDefaultKeys.DARK.rawValue) == false){
            view.window!.overrideUserInterfaceStyle = .light
        }
        else{
            view.window!.overrideUserInterfaceStyle = .dark
        }*/
        viewDidLoad()
        
    }
    
    
    @IBAction func changeLangTapped(_ sender: Any) {
        languagePicker.isHidden=false
    }

    @objc func themeChanged(){
    }
    func setLocalization(){
        languages = [LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_English", comment: ""), LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_Russian", comment: "")]
        titleLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_titleLabel", comment: "")
        langLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_langLabel", comment: "")
        colorLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_colorLabel", comment: "")
        darkModeLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_darkModeLabel", comment: "")
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            changeLanguageButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_English", comment: ""), for: .normal)
        } else {
            changeLanguageButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_Russian", comment: ""), for: .normal)
        }
        
    }
    
    /*public func setUpElements(){
        Utilities.styleButton(changeLanguageButton, colorName: "buttons_1")
    }*/
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
   func numberOfComponents(in pickerView: UIPickerView) -> Int{
            return 1
    }

   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return languages!.count
   }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            self.view.endEditing(true)
            print(languages!)
            return languages![row]
        }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        LocalizationSystem.sharedInstance.setLanguage(languageCode: languagesCodes[row])
        self.languagePicker.isHidden = true
        viewDidLoad()
        viewWillAppear(true)
    }
}


