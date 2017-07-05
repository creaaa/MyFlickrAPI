
import UIKit

final class ViewController: UIViewController {
    
    var manager: InterstingPhotosAPIManager!
    
    //@IBOutlet weak var imageView: SimpleAsyncImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.request() { imgURL in
//            self.imageView.loadImage(urlString: imgURL)
        }
    }
    
}
