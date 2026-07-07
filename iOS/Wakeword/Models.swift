import Foundation

struct Entry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date
    var text: String
}
