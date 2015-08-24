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
    
    var clubs: [JSON] = []

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
        
        cell.rankTXT.text = "\(rank)"
        cell.nameTXT.text = club["clubname"].stringValue
        cell.ptsTXT.text = club["rank"].stringValue
        cell.wTXT.text = club["wins"].stringValue
        cell.lTXT.text = club["losses"].stringValue
        cell.otlTXT.text = club["ties"].stringValue
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let club = clubs[indexPath.row]
        
        var nav = UINavigationController()
        
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("club_detail") as! ClubDetailCTRL
        
        var c: Club = Club(json: club)
        
        c.name = club["clubname"].stringValue
        c.id = club["clubId"].intValue
        c.wins = club["wins"].stringValue.toInt()
        c.losses = club["losses"].stringValue.toInt()
        c.otl = club["ties"].stringValue.toInt()
        c.division = 1
        c.teamID = club["teamId"].intValue
        c.points = club["rank"].stringValue.toInt()
        
        vc.club = c
        
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
                        
                        var tmp: [JSON] = []
                        
                        for (i,club) in json["raw"] {
                            
                            tmp.append(club)
                            
                        }
                        
                        self.clubs = tmp
                        
                        self.clubs.sort( {$0["rank"].stringValue.toInt() > $1["rank"].stringValue.toInt() } )
                        
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