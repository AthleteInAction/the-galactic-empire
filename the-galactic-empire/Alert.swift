import UIKit

class Alert {
    
    static func message(s: String){
        
        var alert = UIAlertController(title: nil, message: s, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        
        if let window :UIWindow = UIApplication.sharedApplication().keyWindow {
            
            window.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            
            var found: Bool = false
            
            for subview in window.subviews {
                if subview.tag == 1 {
                    found = true
                }
            }
            
            if !found {
                
                
                
            }
            
        }
        
    }
    
}