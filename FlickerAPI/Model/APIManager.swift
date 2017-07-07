
import Foundation

struct APIManager {
    
    typealias Photos = PhotoData.Photos.Photo
    
    private enum Result {
        enum FlickrError: Error {
            case invalidJSONData
        }
        case success([Photos])
        case failure(FlickrError)
    }
    
    
    func request(completion: @escaping ([Photos]) -> Void) {
        
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
                    completion(photos)
                case .failure(let error):
                    print(error)
            }
            
        }.resume()
        
    }
    
    
    private func mappingJSON(from data: Data) -> Result {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
            let photos = try decoder.decode(PhotoData.self, from: data)
            return .success(photos.photos.photo)
        } catch {
            return .failure(Result.FlickrError.invalidJSONData)
        }
    }
}

