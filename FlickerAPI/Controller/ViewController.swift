
import UIKit
import Kingfisher

final class ViewController: UIViewController {
    
    typealias Photo = APIManager.Photos
    
    var manager: APIManager!
    var photos:  [Photo]     = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        
        manager.request() { photos in
            ///////////////////////////////////////////////////////////
            // inside here is not a MAIN THREAD, but a WORKER THREAD //
            ///////////////////////////////////////////////////////////
            self.photos = photos
            DispatchQueue.main.async { self.collectionView.reloadData() }
        }
    }
}


extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectedCell =
            self.collectionView.cellForItem(at: indexPath) else { return }
        
        guard let imageView =
            selectedCell.contentView.viewWithTag(1) as? UIImageView else { return }
        
        guard let image = imageView.image else { return }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        
        vc.image = image
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Item", for: indexPath)
        
        guard let imageView =
            item.contentView.viewWithTag(1) as? UIImageView else {
                return item
        }
        
        guard let url = self.photos[indexPath.row].remoteURL else {
            return item
        }
                
        DispatchQueue.global().async {
            DispatchQueue.main.async { imageView.kf.setImage(with: url) }
        }
        
        return item
        
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = self.view.frame.size.width / 3
        return CGSize(width: cellSize, height: cellSize)
    }
}
