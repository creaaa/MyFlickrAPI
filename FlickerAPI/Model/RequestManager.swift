
import Foundation

struct InterstingPhotosAPIManager {
    
    enum Result {
        
        enum FlickrError: Error {
            case invalidJSONData
        }
        
        case success([Photo])
        case failure(FlickrError)
        
    }
    
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    func request(completion: @escaping (String) -> Void) {
        
        let url     = FlickrRequest.interestingPhotosURL
        let request = URLRequest(url: url)
        let task    = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print("error!: \(String(describing: error))")
                return
            }
            
            guard let JSONdata = data else { return }
            
            let result = self.traversePhotos(from: JSONdata)
            
            switch result {
                case .success(let photo):
                    completion(photo[2].remoteURL.description)
                case .failure(let error):
                    print(error)
            }
        }
        
        task.resume()
        
    }
    
    
    func traversePhotos(from data: Data) -> Result {
        
        guard let jsonObject =
            try? JSONSerialization.jsonObject(with: data, options: []) else {
                return .failure(Result.FlickrError.invalidJSONData)
        }
        
        guard let jsonDict = jsonObject as? [AnyHashable:Any] else {
            return .failure(Result.FlickrError.invalidJSONData)
        }
        
        guard let photos = jsonDict["photos"] as? [String:Any] else {
            return .failure(Result.FlickrError.invalidJSONData)
        }
        
        guard let photo = photos["photo"] as? [[String:Any]] else {
            return .failure(Result.FlickrError.invalidJSONData)
        }
        
        print(photo)
        
        var finalPhotos: [Photo] = []
        
        for photoJSON: [String:Any] in photo {
            // なんでここでstatic method 呼べるんや。。。
            // 結論: instance method からは static method を呼べる。
            if let photo = InterstingPhotosAPIManager.traversePhoto(fromJSON: photoJSON) {
                finalPhotos.append(photo)
            }
        }
        
        print(finalPhotos[0])
        
        if finalPhotos.isEmpty && !photo.isEmpty {
            return .failure(Result.FlickrError.invalidJSONData)
        }
        
        return .success(finalPhotos)
        
    }
 
    static func traversePhoto(fromJSON json: [String:Any]) -> Photo? {
        
        guard let photoID        = json["id"]        as? String,
              let title          = json["title"]     as? String,
        
              let photoURLString = json["url_h"]     as? String,
              let URL = URL(string: photoURLString),
            
              let date = json["datetaken"] as? String,
              // ここはstatic methodじゃないと認識されない。。。
              let dateTaken = formatDate(date) else {
                return nil
        }
        
        // 結論: static method からは instance method を呼べない。
        // hoge()
        
        return Photo(ID: photoID, title: title, remoteURL: URL, dateTaken: dateTaken)
        
    }
    
    static func formatDate(_ str: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'"
        
        let res = formatter.date(from: str)
        
        return res
        
    }
    
    func hoge() {}
    static func fuga() {}
    
}



