
import Foundation

struct FlickrRequest {
    
    enum Method: String {
        case interestingPhotos = "flickr.interestingness.getlist"
    }
    
    private static let base       = "https://api.flickr.com/services/rest"
    private static let API_KEY    = "4852fcab11abc3afa216b6c960fc102e"
    private static let API_SECRET = "f83fe10a105e0db3"
    
    // end point
    static var interestingPhotosURL: URL {
        return flickrURL(method: .interestingPhotos,
                         parameters: ["extras":"url_h, date_taken"])
    }
    
    private static func flickrURL(method: Method,
                                  parameters: [String:String]?) -> URL {
        
        var components = URLComponents(string: base)!
        
        var queryItems: [URLQueryItem] = []
        
        let baseParams = [
            "method":         method.rawValue,
            "format":         "json",
            "api_key":        API_KEY,
            "nojsoncallback": "1"
        ]
        
        /*
        for (key, value) in baseParams {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        */
        
        baseParams.forEach { element in
            queryItems.append(URLQueryItem(name: element.key, value: element.value))
        }
        
        /*
        if let extra = parameters {
            /*
            for (key, value) in extra {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
             */
            
            extra.forEach { element in
                queryItems.append(URLQueryItem(name: element.key, value: element.value))
            }
        }
        */
        
        _ = parameters.map {
            $0.map {
                queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
            }
        }
        
        components.queryItems = queryItems
        
        return (components.url)!
        
    }
}
