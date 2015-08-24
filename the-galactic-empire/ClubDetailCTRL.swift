//
//  ClubDetailCTRL.swift
//  the-galactic-empire
//
//  Created by grobinson on 8/17/15.
//  Copyright (c) 2015 wambl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ClubDetailCTRL: UITableViewController {
    
    var club: Club!

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var recordTXT: UILabel!
    @IBOutlet weak var divisionTXT: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = club.name
        
        img.contentMode = UIViewContentMode.ScaleAspectFit
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if self.club.teamID == nil {
                
                self.setTeamID()
                
            } else {
                
                self.setImage()
                
            }
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func setTeamID(){
        println("SET TEAM ID")
        
        self.title = club.name
        
        let s = "https://www.easports.com/iframe/nhl14proclubs/api/platforms/xbox/clubs/\(club.id)/info"
        
        Alamofire.request(.GET, s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, parameters: nil)
            .responseJSON { request, response, data, error in
                
                if error == nil {
                    
                    if response?.statusCode == 200 {
                        
                        var json = JSON(data!)
                        
                        self.club.teamID = json["raw"][0]["teamId"].intValue
                        
                        self.setImage()
                        
                    } else {
                        
                        println("Status Code Error: \(response?.statusCode)")
                        println(request)
                        
                    }
                    
                } else {
                    
                    println("Error!")
                    println(error)
                    println(request)
                    
                }
                
                self.loader.stopAnimating()
                
        }
        
        recordTXT.text = "\(club.wins) - \(club.losses) - \(club.otl)"
        divisionTXT.text = "Division: \(club.division)"
        
    }
    
    func setImage(){
        println("SET IMAGE")
        
        if club.img == nil {
            
            let s = "https://www.easports.com/iframe/nhl14proclubs/bundles/nhl/dist/images/crests/d\(club.teamID!).png"
            println(s)
            
            if let url = NSURL(string: s) {
                
                if let data = NSData(contentsOfURL: url){
                    println("IMG")
                    img.image = UIImage(data: data)
                    
                }
                
            }
            
        } else {
            
            img.image = club.img
            
        }
        
        self.loader.stopAnimating()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "seg_club_to_roster" {
            
            var vc = segue.destinationViewController as! ClubDetailRosterCTRL
            
            vc.club = club
            
        }
        
        if segue.identifier == "seg_club_to_recent" {
            
            var vc = segue.destinationViewController as! ClubDetailRecentCTRL
            
            vc.club = club
            
        }
        
    }
    
    func getRecord(){
        
        println("GET RECORD")
        let s = "https://www.easports.com/iframe/nhl14proclubs/api/platforms/xbox/clubs/\(club.id)/stats"
        
        Alamofire.request(.GET, s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, parameters: nil)
            .responseJSON { request, response, data, error in
                
                if error == nil {
                    
                    if response?.statusCode == 200 {
                        
                        let json = JSON(data!)
                        
                        let t = json["raw"]["\(self.club.id)"] as JSON
                        
                        self.club.wins = t["wins"].stringValue.toInt()
                        self.club.losses = t["losses"].stringValue.toInt()
                        self.club.otl = t["otl"].stringValue.toInt()
                        self.club.division = t["curDivision"].stringValue.toInt()
                        
                        self.recordTXT.text = "\(self.club.wins) - \(self.club.losses) - \(self.club.otl)"
                        
                    } else {
                        
                        println("Status Code Error: \(response?.statusCode)")
                        println(request)
                        
                    }
                    
                } else {
                    
                    println("Error!")
                    println(error)
                    println(request)
                    
                }
                
        }
    
    }

}