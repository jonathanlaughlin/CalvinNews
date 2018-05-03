//
//  OldNewsTableViewController.swift
//  CalvinNews
//
//  Created by jlaughli on 5/2/18.
//  Copyright © 2018 Jonathan Laughlin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OldNewsTableViewController: UITableViewController {
    
    var delegate : CanGetDate?
    var data : Date?
    let defaults = UserDefaults.standard
    var newsStories = [NewsStory]()
    var selectedStory = NewsStory()
    var calvinURL: String = ""
    var startDate: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatDate(dateToUse: data!)
        
        loadStories()
    }

    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsStories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "oldNewsStoryCell", for: indexPath)
        
        let story = newsStories[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        //        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        cell.textLabel?.text = story.headline
        
        return cell
    }
    
    //MARK: Tableview data
    
    func loadStories() {
        
        let sourcePref = defaults.integer(forKey: "Source")
        var displayOn: String = ""
        
        if sourcePref == 1 {
            displayOn = "displayOnStudentNews:*yes*"
        }
        else {
            displayOn = "displayOnCalvinNews:*yes*"
        }
        
        
        calvinURL = "https://calvin.edu/api/content/render/false/type/json/query/+contentType:CcAnnouncements%20+(conhost:cd97e902-9dba-4e51-87f9-1f712806b9c4%20conhost:SYSTEM_HOST)%20+CcAnnouncements.startDate:"+startDate+"*%20+CcAnnouncements."+displayOn+"%20+languageId:1%20+deleted:false%20+live:true/orderby/CcAnnouncements.startDate"
        
        print(calvinURL)
        
        Alamofire.request(calvinURL, method: .get).responseJSON { (response) in
            
            if response.result.isSuccess {
                if let json : JSON = JSON(response.result.value!) {
                
                    for item in json["contentlets"].arrayValue {
                        let news = NewsStory()
                        //news.body = item["shortSummary"].stringValue
                        news.body = item["bodyWysiwyg"].stringValue
                        news.headline = item["headline"].stringValue
                        news.imageURL = "https://calvin.edu" + item["bannerImage"].stringValue
                        
                        self.newsStories.append(news)
                    }
                    
                    self.tableView.reloadData()
                }
            }
            else {
                print("ERROR: \(String(describing: response.result.error))")
            }
        }
    }
    
    func formatDate(dateToUse: Date) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        startDate = formatter.string(from: dateToUse)
        
        
    }
    
    
}

//MARK: protocols for delegate methods
protocol CanGetDate {
    
    func dateReceived(data: Date)
    
}
