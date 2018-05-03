//
//  PreferencesViewController.swift
//  CalvinNews
//
//  Created by jlaughli on 4/30/18.
//  Copyright © 2018 Jonathan Laughlin. All rights reserved.
//

import UIKit

protocol ChangeSource {

    func sourceChange()
    
}

class PreferencesViewController: UIViewController {
    
    var delegate : ChangeSource?
    var data = ""
    
    @IBOutlet weak var sourceSegmented: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        sourceSegmented.selectedSegmentIndex = defaults.integer(forKey: "Source")
        
        super.viewDidLoad()
    
    }

    
    @IBAction func sourcePrefChanged(_ sender: Any) {
        
        let segmentSelected = sourceSegmented.selectedSegmentIndex
        
        defaults.set(segmentSelected, forKey: "Source")
        
        delegate?.sourceChange()
        
    }

}
