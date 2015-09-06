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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Loading.start()
        
        club.getRecent { (s) -> Void in
            
            if s {
                
                self.tableView.reloadData()
                
            }
            
            Loading.stop()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let recent = club.recent {
            
            return recent.count
            
        } else {
            
            return 0
            
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! RecentGameCell
        
        let match = club.recent![indexPath.row]
        
        cell.club = club
        cell.match = match
        
        cell.v = self
        
        cell.scoreTXT.text = match.score
        
        cell.whenTXT.text = match.timeAgo
        
        cell.nameHome.text = match.home.name
        cell.imgHome.image = match.home.img
        cell.shotsHome.text = "Shots: \(match.homeShots)"
        cell.statsHome.tag = match.home.id
        
        cell.nameAway.text = match.away.name
//        cell.imgAway.image = match.away.img
        cell.shotsAway.text = "Shots: \(match.awayShots)"
        cell.statsAway.tag = match.away.id
        
        if match.away.img == nil {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                // do some task
                dispatch_async(dispatch_get_main_queue(), {
                    // update some UI
                    match.away.setImage({ (s) -> Void in
                        
                        cell.imgAway.image = match.away.img
                        
                    })
                });
            });
            
        }
        
        return cell
        
    }

}
