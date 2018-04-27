//
//  StoryViewController.swift
//  CalvinNews
//
//  Created by jlaughli on 4/26/18.
//  Copyright © 2018 Jonathan Laughlin. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import ChameleonFramework

protocol CanReceive {
    
    func dataReceived(data: NewsStory)
    
}

class StoryViewController: UIViewController {
    
    var delegate : CanReceive?
    
    var data : NewsStory?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelForHeadline: UILabel!
    
    @IBOutlet weak var labelForBody: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigatio controller does not exist") }
        
        navBar.tintColor = UIColor(hexString: "FEF95D")
        
        labelForHeadline.text = data?.headline

        labelForBody.text = data?.body
        
        imageView.sd_setImage(with: Foundation.URL(string: (data?.imageURL)!))
    }
    
    override func viewWillLayoutSubviews() {
        labelForBody.sizeToFit()
        
    }
    
}
