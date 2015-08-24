//
//  ClubDetailRecentCTRL.swift
//  the-galactic-empire
//
//  Created by grobinson on 8/17/15.
//  Copyright (c) 2015 wambl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ClubDetailRecentCTRL: UITableViewController {
    
    var club: Club!
    
    var games: [JSON] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.setData()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return club.recent.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! RecentGameCell
        
        let match = club.recent[indexPath.row]
        
        cell.club = club
        cell.match = match
        
        cell.v = self
        
        cell.scoreTXT.text = match.score
        
        cell.whenTXT.text = match.timeAgo
        
        cell.nameHome.text = match.homeName
        cell.imgHome.image = match.homeImage
        cell.shotsHome.text = "Shots: \(match.homeShots)"
        cell.statsHome.tag = match.homeID
        
        cell.nameAway.text = match.awayName
        cell.imgAway.image = match.awayImage
        cell.shotsAway.text = "Shots: \(match.awayShots)"
        cell.statsAway.tag = match.awayID
        
        
        
        return cell
        
    }
    
    func setData(){
        
        Loading.start()
        
        let s = "https://www.easports.com/iframe/nhl14proclubs/api/platforms/xbox/clubs/\(club.id)/matches"
        
        Alamofire.request(.GET, s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, parameters: ["filters":"sum,pretty","match_type":"gameType5","matches_returned":"5"])
            .responseJSON { request, response, data, error in
                
                if error == nil {
                    
                    if response?.statusCode == 200 {
                        
                        var json = JSON(data!)
                        
                        self.club.setRecent(json)
                        
                        self.tableView.reloadData()
                        
                    } else {
                        
                        println("Status Code Error: \(response?.statusCode)")
                        println(request)
                        
                    }
                    
                } else {
                    
                    println("Error!")
                    println(error)
                    println(request)
                    
                }
                
                Loading.stop()
                
        }
        
    }

}
