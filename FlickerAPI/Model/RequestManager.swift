
import Foundation

struct InterstingPhotosAPIManager {
    
    enum Result {
        typealias Photo = PhotoData.Photos.Photo
        enum FlickrError: Error {
            case invalidJSONData
        }
        case success([Photo])
        case failure(FlickrError)
    }
    
    
    func request(completion: @escaping (URL) -> Void) {
        
        let session: URLSession = {
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config)
        }()
        
        let url     = FlickrRequest.interestingPhotosURL
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print("error!: \(String(describing: error))")
                return
            }
            
            guard let data = data else { return }
            
            let result = self.mappingJSON(from: data)
            
            switch result {
                case .success(let photos):
                    guard let url = photos[1].url_h else { return }
                    completion(url)
                case .failure(let error):
                    print(error)
            }
            
        }.resume()
        
    }
    
    
    func mappingJSON(from data: Data) -> Result {
        
        let formatter = DateFormatter()
        // ここの文字列、jsonのstringとフォーマットを一致させないとdate(from:)は失敗する。あぶねぇ
        formatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
            let photos = try decoder.decode(PhotoData.self, from: data)
            print(photos, separator: "")
            return .success(photos.photos.photo)
        } catch {
            return .failure(Result.FlickrError.invalidJSONData)
        }
    }
    
}


