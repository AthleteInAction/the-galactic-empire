import Alamofire
import SwiftyJSON

class Club {
    
    var id: Int!
    var teamID: Int?
    var name: String?
    var wins: Int?
    var losses: Int!
    var otl: Int!
    var region: String!
    var img: UIImage?
    var recent: [Match]?
    var roster: [JSON]?
    var rank: Int!
    
    private var regions: [String] = ["N/A","WEST COAST","EAST COAST","EUROPE"]
    
    init(
        id _id: Int
    ){
        
        id = _id
        
    }
    
    func setFromSearch(json: JSON){
        
        id = json["clubId"].stringValue.toInt()
        name = json["name"].stringValue
        wins = json["wins"].intValue
        losses = json["losses"].intValue
        otl = json["otl"].intValue
        
    }
    
    func setFromRecent(json: JSON){
        
        teamID = json["clubs"]["\(id)"]["details"]["teamId"].intValue
        name = json["clubs"]["\(id)"]["details"]["name"].stringValue
        region = regions[json["clubs"]["\(id)"]["details"]["regionId"].intValue]
        
    }
    
    func getInfo(completion: (s: Bool) -> Void){
        
        let s = "https://www.easports.com/iframe/nhl14proclubs/api/platforms/xbox/clubs/\(id)/info"
        
        Alamofire.request(.GET, s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, parameters: nil)
            .responseJSON { request, response, data, error in
                
                if error == nil {
                    
                    if response?.statusCode == 200 {
                        
                        let json = JSON(data!)
                        
                        let t = json["raw"][0]
                        
                        self.name = t["name"].stringValue
                        self.teamID = t["teamId"].intValue
                        self.region = self.regions[t["regionId"].intValue]
                        
                        completion(s: true)
                        
                    } else {
                        
                        println("Status Code Error: \(response?.statusCode)")
                        println(request)
                        
                        completion(s: false)
                        
                    }
                    
                } else {
                    
                    println("Error!")
                    println(error)
                    println(request)
                    
                    completion(s: false)
                    
                }
                
        }
        
    }
    
    func getStats(completion: (s: Bool) -> Void){
        
        let s = "https://www.easports.com/iframe/nhl14proclubs/api/platforms/xbox/clubs/\(id)/stats"
        
        Alamofire.request(.GET, s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, parameters: nil)
            .responseJSON { request, response, data, error in
                
                if error == nil {
                    
                    if response?.statusCode == 200 {
                        
                        let json = JSON(data!)
                        
                        let t = json["raw"]["\(self.id)"] as JSON
                        
                        self.wins = t["wins"].stringValue.toInt()
                        self.losses = t["losses"].stringValue.toInt()
                        self.otl = t["otl"].stringValue.toInt()
                        
                        completion(s: true)
                        
                    } else {
                        
                        println("Status Code Error: \(response?.statusCode)")
                        println(request)
                        
                        completion(s: false)
                        
                    }
                    
                } else {
                    
                    println("Error!")
                    println(error)
                    println(request)
                    
                    completion(s: false)
                    
                }
                
        }
        
    }
    
    func setImage(completion: (s: Bool) -> Void){
        
        let s = "https://www.easports.com/iframe/nhl14proclubs/bundles/nhl/dist/images/crests/d\(teamID!).png"
        
        if let url = NSURL(string: s) {
            
            if let data = NSData(contentsOfURL: url){
                
                img = UIImage(data: data)
                
                completion(s: true)
                
            } else {
                
                println("SET IMAGE A")
                completion(s: false)
                
            }
            
        } else {
            
            println("SET IMAGE B")
            completion(s: false)
            
        }
        
    }
    
    func getRoster(completion: (s: Bool) -> Void){
        
        let s = "https://www.easports.com/iframe/nhl14proclubs/api/platforms/xbox/clubs/\(id)/membersComplete"
        
        Alamofire.request(.GET, s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, parameters: nil)
            .responseJSON { request, response, data, error in
                
                if error == nil {
                    
                    if response?.statusCode == 200 {
                        
                        var json = JSON(data!)
                        
                        var tmp: [JSON] = []
                        
                        for (key,val) in json["raw"] {
                            
                            tmp.append(val)
                            
                        }
                        
                        self.roster = tmp
                        
                        completion(s: true)
                        
                    } else {
                        
                        println("Status Code Error: \(response?.statusCode)")
                        println(request)
                        
                        completion(s: false)
                        
                    }
                    
                } else {
                    
                    println("Error!")
                    println(error)
                    println(request)
                    
                    completion(s: false)
                    
                }
                
        }
        
    }
    
    func getRecent(completion: (s: Bool) -> Void){
        
        let s = "https://www.easports.com/iframe/nhl14proclubs/api/platforms/xbox/clubs/\(id)/matches"
        
        Alamofire.request(.GET, s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, parameters: ["filters":"sum,pretty","match_type":"gameType5","matches_returned":"5"])
            .responseJSON { request, response, data, error in
                
                if error == nil {
                    
                    if response?.statusCode == 200 {
                        
                        var json = JSON(data!)
                        
                        var tmp: [Match] = []
                        
                        for (key,val) in json["raw"] {
                            
                            let m = Match(json: val, homeId: self.id)
                            
                            m.home = self
                            
                            tmp.append(m)
                            
                        }
                        
                        tmp.sort({ $0.timestamp > $1.timestamp })
                        
                        self.recent = tmp
                        
                        completion(s: true)
                        
                    } else {
                        
                        println("Status Code Error: \(response?.statusCode)")
                        println(request)
                        
                        completion(s: true)
                        
                    }
                    
                } else {
                    
                    println("Error!")
                    println(error)
                    println(request)
                    
                    completion(s: true)
                    
                }
                
        }
        
    }
    
    func setRegion(i: Int!){
        
        region = regions[i]
        
    }
    
}

class Match {
    
    var score: String!
    var timestamp: Int!
    var timeAgo: String!
    
    var away: Club!
    var awayShots: Int!
    var awayPlayers: [JSON]?
    var awayResult: String!
    
    var home: Club!
    var homeShots: Int!
    var homePlayers: [JSON]?
    var homeResult: String!
    
    var body: JSON!
    
    init (
        json: JSON,homeId _homeId: Int
    ){
        
        body = json
        
        timestamp = json["timestamp"].intValue
        timeAgo = json["timeAgo"].stringValue
        
        for (key,val) in json["clubs"] {
            
            if _homeId == key.toInt() {
                
                home = Club(id: key.toInt()!)
                home.setFromRecent(body)
                
            } else {
                
                away = Club(id: key.toInt()!)
                away.setFromRecent(body)
                
                score = val["scorestring"].stringValue
                
            }
            
        }
        
        for (key,val) in json["aggregate"] {
            
            if _homeId == key.toInt() {
                
                homeShots = val["skshots"].intValue
                
            } else {
                
                awayShots = val["skshots"].intValue
                
            }
            
        }
        
        for (key,val) in json["players"] {
            
            if _homeId == key.toInt() {
                
                var tmp: [JSON] = []
                
                for (id,p) in val {
                    
                    tmp.append(p)
                    
                }
                
                homePlayers = tmp
                
            } else {
                
                var tmp: [JSON] = []
                
                for (id,p) in val {
                    
                    tmp.append(p)
                    
                }
                
                awayPlayers = tmp
                
            }
            
        }
        
    }
    
}