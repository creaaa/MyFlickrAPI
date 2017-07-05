
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let rootViewController  = window?.rootViewController as! UINavigationController
        let photoViewController = rootViewController.topViewController as! ViewController
        
        photoViewController.manager = InterstingPhotosAPIManager()
        
        return true
        
    }
}
