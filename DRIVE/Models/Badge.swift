import Foundation

struct Badge: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let icon: String
    let description: String
    let earnedDate: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        description: String,
        earnedDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.description = description
        self.earnedDate = earnedDate
    }
}
