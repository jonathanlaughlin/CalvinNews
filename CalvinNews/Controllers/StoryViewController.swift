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
import Alamofire

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
        
        let newsImageURL = Foundation.URL(string: (data?.imageURL)!)
        let placeholderImageURL = Foundation.URL(string: "https://calvin.edu/global/images/calvin-college-nameplate.jpeg")

        Alamofire.request(newsImageURL!, method: .get).responseData { (responseData) in
            
            if responseData.error != nil {
                self.imageView.sd_setImage(with: placeholderImageURL)
            }
            else {
                self.imageView.sd_setImage(with: newsImageURL)
            }
            
        }
        
        
    }
    
    override func viewWillLayoutSubviews() {
        labelForBody.sizeToFit()
        
    }
    
}
