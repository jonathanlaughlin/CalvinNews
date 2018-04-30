//
//  ViewController.swift
//  CalvinNews
//
//  Created by jlaughli on 4/25/18.
//  Copyright © 2018 Jonathan Laughlin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsViewController: UITableViewController, CanReceive {
    
    func dataReceived(data: NewsStory) {
        // nothing
    }
    
    
    var newsStories = [NewsStory]()
    
    var selectedStory = NewsStory()
    
    // Test URL for News & Stories
//    let calvinURL = "https://calvin.edu/api/content/render/false/type/json/query/+contentType:CcNewsStories%20+(conhost:cd97e902-9dba-4e51-87f9-1f712806b9c4%20conhost:SYSTEM_HOST)%20+languageId:1%20+deleted:false%20+live:true/limit/18/orderby/CcNewsStories.publishDate%20desc"
    
    let calvinURL = "https://calvin.edu/api/content/render/false/type/json/query/+contentType:CcAnnouncements%20+(conhost:cd97e902-9dba-4e51-87f9-1f712806b9c4%20conhost:SYSTEM_HOST)%20+CcAnnouncements.startDate:20250427*%20+languageId:1%20+deleted:false%20+working:true/orderby/CcAnnouncements.startDate"

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        var menuView = UIView
        
        loadStories()
        
    }

    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return newsStories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsStoryCell", for: indexPath)
        
        let story = newsStories[indexPath.row]

        cell.textLabel?.text = story.headline
        
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedStory = newsStories[indexPath.row]
//        print(selectedStory.headline)
        
        performSegue(withIdentifier: "readNewsItem", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "readNewsItem" {

            let secondVC = segue.destination as! StoryViewController

            secondVC.data = selectedStory
            
            secondVC.delegate = self

        }

    }
    
    //MARK: Data Manipulation Methods
    
    func loadStories() {

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
                print("ERROR \(String(describing: response.result.error))")
            }

        }

    }
    
}

