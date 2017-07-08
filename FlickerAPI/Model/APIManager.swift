
import Foundation

struct APIManager {
    
    typealias Photos = PhotoData.Photos.Photo
    
    enum FlickrError: Error {
        case invalidJSONData
    }
    
    private enum Result<T, Error> {
        case success(T)
        case failure(Error)
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
        
        session.finishTasksAndInvalidate() // if yu miss
        
        // task.resume()
        
    }
    
    
    private func mappingJSON(from data: Data) -> Result<[Photos], FlickrError> {
        
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
            let photos = try decoder.decode(PhotoData.self, from: data)
            return .success(photos.photos.photo)
        } catch {
            return .failure(.invalidJSONData)
        }
    }
}

