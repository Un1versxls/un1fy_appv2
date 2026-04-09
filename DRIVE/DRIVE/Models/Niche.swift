import Foundation

struct Niche: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let description: String
    let icon: String
    let isPremium: Bool
    let difficulty: DifficultyLevel
    let color: String
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        icon: String,
        isPremium: Bool = false,
        difficulty: DifficultyLevel = .beginner,
        color: String = "#6B7280"
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.isPremium = isPremium
        self.difficulty = difficulty
        self.color = color
    }
    
    static let `default` = Niche(
        name: "General",
        description: "General productivity and habit building",
        icon: "star.fill",
        difficulty: .beginner,
        color: "#6B7280"
    )
    
    static let sampleList: [Niche] = [
        Niche(name: "Fitness", description: "Build consistent workout habits", icon: "dumbbell.fill", difficulty: .intermediate, color: "#EF4444"),
        Niche(name: "Meditation", description: "Master daily mindfulness practice", icon: "brain.head.profile", difficulty: .beginner, color: "#10B981"),
        Niche(name: "Reading", description: "Develop daily reading routines", icon: "book.fill", difficulty: .beginner, color: "#3B82F6"),
        Niche(name: "Coding", description: "Learn and practice coding daily", icon: "chevron.left.forwardslash.chevron.right", difficulty: .intermediate, color: "#F59E0B"),
        Niche(name: "Writing", description: "Write consistently every day", icon: "pencil.and.outline", difficulty: .intermediate, color: "#EC4899", isPremium: true),
        Niche(name: "Nutrition", description: "Improve your eating habits", icon: "leaf.fill", difficulty: .beginner, color: "#10B981", isPremium: true)
    ]
    
    static let allNiches: [Niche] = sampleList
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, icon, isPremium, difficulty, color
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        icon = try container.decode(String.self, forKey: .icon)
        isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium) ?? false
        let difficultyString = try container.decodeIfPresent(String.self, forKey: .difficulty)
        difficulty = difficultyString.flatMap { DifficultyLevel(rawValue: $0) } ?? .beginner
        color = try container.decodeIfPresent(String.self, forKey: .color) ?? "#6B7280"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(icon, forKey: .icon)
        try container.encode(isPremium, forKey: .isPremium)
        try container.encode(difficulty.rawValue, forKey: .difficulty)
        try container.encode(color, forKey: .color)
    }
}