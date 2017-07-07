
import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var                image:     UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image
    }

}
