
import Foundation

struct PhotoData: Codable {
    struct Photos: Codable {
        struct Photo: Codable, CustomStringConvertible {
            // "new name" : "actual JSON key name"
            private enum CodingKeys: String, CodingKey {
                case id        = "id"
                case title     = "title"
                case remoteURL = "url_h"
                case dateTaken = "datetaken"
            }
            
            let id:        String
            let title:     String
            let remoteURL: URL?
            let dateTaken: Date
            
            var description: String {
                return """
                id:        \(self.id)
                title:     \(self.title)
                remoteURL: \(self.remoteURL as Any)
                date:      \(self.dateTaken)
                """
            }
        }
        let photo: [Photo]
    }
    let photos: Photos
}
