
import UIKit

final class ViewController: UIViewController {
    
    typealias Photo = InterstingPhotosAPIManager.Photos
    
    var manager: InterstingPhotosAPIManager!
    var photos:  [Photo] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        
        manager.request() { photos in
            
            // パターン1
            // self.imageView.loadImage(urlString: imgURL)
            
            // パターン2 (単に写真を1枚だけ出す場合)
            /*
            let url = URL(string: imgURL)
            let imageData = try! Data(contentsOf: imgURL)
            
            // 新事実発覚！！この中、メインスレッドではない！！！！！
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
            */
            
            self.photos = photos
            
            // collectionViewを使う場合
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            
        }
    }
}


extension ViewController: UICollectionViewDelegate {
    
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
        
        let imageData   = try! Data(contentsOf: url)
        imageView.image = UIImage(data: imageData)
        
        /*
        self.photos.forEach { photo in
            guard let url = self.photos[indexPath.row].remoteURL else {
                return UICollectionViewCell()
            }
            let imageData   = try! Data(contentsOf: url)
            imageView.image = UIImage(data: imageData)
        }
        */
        return item
        
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    // Screenサイズに応じたセルサイズを返す
    // UICollectionViewDelegateFlowLayoutの設定が必要
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize:CGFloat = self.view.frame.size.width/2-2
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)
    }
    
}

