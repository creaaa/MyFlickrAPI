
import UIKit

final class ViewController: UIViewController {
    
    var manager: InterstingPhotosAPIManager!
    
    @IBOutlet weak var imageView: SimpleAsyncImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.request() { imgURL in
            // パターン1
            // self.imageView.loadImage(urlString: imgURL)
            
            // パターン2
            // let url = URL(string: imgURL)
            let imageData = try! Data(contentsOf: imgURL)
            // 新事実発覚！！この中、メインスレッドではない！！！！！
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
        }
    }
}
