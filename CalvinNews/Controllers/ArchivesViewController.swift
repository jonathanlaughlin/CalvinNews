//
//  ArchivesViewController.swift
//  CalvinNews
//
//  Created by jlaughli on 5/1/18.
//  Copyright © 2018 Jonathan Laughlin. All rights reserved.
//

import UIKit

class ArchivesViewControler: UITableViewController, CanGetDate {
    
    var datesToCycle = [Date]()
    
    var selectedDate = Date()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getPreviousTenNewsDates()
        
    }
    
    //MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedDate = datesToCycle[indexPath.row]
        
        performSegue(withIdentifier: "getArchivedStoriesSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC = segue.destination as! OldNewsTableViewController
        
        nextVC.data = selectedDate
        
        nextVC.delegate = self
        
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datesToCycle.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "archiveDateCell", for: indexPath)
        
        let dateForCell = datesToCycle[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        let stringDate = formatter.string(from: dateForCell)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        cell.textLabel?.text = stringDate
        
        return cell
    }
    
    
    func getPreviousTenNewsDates() {
        
        let today = Date()
        
        
        for y in 0...15 {
            
            let x = -y
            
            let dayBefore = Calendar.current.date(byAdding: .day, value: x, to: today)
            let dayOfWeek = Calendar.current.component(.weekday, from: Calendar.current.date(byAdding: .day, value: x, to: today)!)
            
            // omit Sundays and Saturdays
            if dayOfWeek != 1 && dayOfWeek != 7 {
                datesToCycle.append(dayBefore!)
            }
        }

    }
    
    //MARK: protocol methods
    func dateReceived(data: Date) {
        // do nada
    }
    
}
