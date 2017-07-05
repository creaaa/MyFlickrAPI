
import Foundation

struct PhotoData: Codable {
    
    struct Photos: Codable {
        // (とりあえず、 id: String, title: String?, url_h: URL? で1回通ったことある。)
        struct Photo: Codable, CustomStringConvertible {
            let id: String        // ここ、Intにするとエラー！
            let title:     String // やばかったら ? に戻して
            let url_h:     URL? // ここでぬるぽになった！ ここは ? 必須！
            let datetaken: Date
            
            var description: String {
                return """
                id:    \(self.id)
                title: \(self.title)
                url_h: \(self.url_h as Any)
                date:  \(self.datetaken)
                \n
                """
            }
        }
        let photo: [Photo]
    }
    let photos: Photos // [Photo]ではない？？もしや？？　ビンゴ。{}は[]でやるな。即エラー。
}
