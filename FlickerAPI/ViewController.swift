
import UIKit

enum Hoge {
    case success(hoge: Int)
    case failure(fuga: String)
}

final class ViewController: UIViewController {
    
    var manager: InterstingPhotosAPIManager!
    
    // @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageView: SimpleAsyncImageView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        manager.request() { imgURL in
            self.imageView.loadImage(urlString: imgURL)
        }
                
    }
    
}
