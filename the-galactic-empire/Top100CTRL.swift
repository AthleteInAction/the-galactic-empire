//
//  Top100CTRL.swift
//  the-galactic-empire
//
//  Created by grobinson on 8/19/15.
//  Copyright (c) 2015 wambl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Top100CTRL: UITableViewController {
    
    var clubs: [Club] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return clubs.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! Top100Cell
        
        let club = clubs[indexPath.row]
        
        let rank = indexPath.row + 1
        
        cell.nameTXT.text = club.name
        cell.rankTXT.text = "\(rank)"
        cell.ptsTXT.text = "\(club.rank)"
        cell.wTXT.text = "\(club.wins!)"
        cell.lTXT.text = "\(club.losses)"
        cell.otlTXT.text = "\(club.otl)"
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let club = clubs[indexPath.row]
        
        var nav = UINavigationController()
        
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("club_detail") as! ClubDetailCTRL
        vc.club = club
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getData() -> Bool {
        
        Loading.start()
        
        let s = "https://www.easports.com/iframe/nhl14proclubs/api/platforms/xbox/clubRankLeaderboard"
        
        Alamofire.request(.GET, s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, parameters: nil)
            .responseJSON { request, response, data, error in
                
                if error == nil {
                    
                    if response?.statusCode == 200 {
                        
                        var json = JSON(data!)
                        
                        var tmp: [Club] = []
                        
                        for (i,club) in json["raw"] {
                            
                            let c = Club(id: club["clubId"].intValue)
                            
                            c.teamID = club["teamId"].intValue
                            c.name = club["name"].stringValue
                            c.rank = club["rank"].stringValue.toInt()
                            c.wins = club["wins"].stringValue.toInt()
                            c.losses = club["losses"].stringValue.toInt()
                            c.otl = club["ties"].stringValue.toInt()
                            c.setRegion(club["regionId"].intValue)
                            
                            tmp.append(c)
                            
                        }
                        
                        self.clubs = tmp
                        
                        self.clubs.sort({ $0.rank > $1.rank })
                        
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
        
        return true
        
    }

}