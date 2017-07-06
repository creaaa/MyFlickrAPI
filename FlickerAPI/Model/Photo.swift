
import Foundation

struct PhotoData: Codable {
    struct Photos: Codable {
        struct Photo: Codable, CustomStringConvertible {
            // "変更したいプロパティ名" : "実際のキー名"
            private enum CodingKeys: String, CodingKey {
                case id        = "id"
                case title     = "title"
                case remoteURL = "url_h"
                case dateTaken = "datetaken"
            }
            
            let id:        String // ここ、Intにするとエラー！
            let title:     String // やばかったら ? に戻して
            let remoteURL: URL?   // ここでぬるぽになった！ ここは ? 必須！
            let dateTaken: Date
            
            var description: String {
                return """
                id:    \(self.id)
                title: \(self.title)
                remoteURL: \(self.remoteURL as Any)
                date:  \(self.dateTaken)
                \n
                """
            }
            
        }
        let photo: [Photo]
    }
    let photos: Photos // [Photo]ではない？？もしや？？　ビンゴ。{}は[]でやるな。即エラー。
}
