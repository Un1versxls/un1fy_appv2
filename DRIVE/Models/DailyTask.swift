import Foundation

struct DailyTask: Codable, Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String?
    let targetDate: Date
    var completedDate: Date?
    var xpReward: Int
    var nicheObject: Niche?
    var status: TaskStatus
    var category: TaskCategory
    
    var isCompleted: Bool { completedDate != nil }
    
    var points: Int { xpReward }
    var pointsLabel: String { "+\(xpReward)" }
    
    var timeLabel: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: targetDate)
    }
    
    var niche: String { nicheObject?.name ?? "General" }
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        targetDate: Date,
        completedDate: Date? = nil,
        xpReward: Int = 10,
        nicheObject: Niche? = nil,
        status: TaskStatus = .pending,
        category: TaskCategory = .quick
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.targetDate = targetDate
        self.completedDate = completedDate
        self.xpReward = xpReward
        self.nicheObject = nicheObject
        self.status = status
        self.category = category
    }
    
    static func generateForDate(_ date: Date, count: Int = 3) -> [DailyTask] {
        let templates: [(String, TaskCategory)] = [
            ("Complete morning routine", .quick),
            ("20 minutes focused practice", .engagement),
            ("Review daily progress", .creation),
            ("Mindfulness exercise", .research),
            ("Daily learning session", .admin)
        ]
        let shuffled = templates.shuffled()
        let selected = Array(shuffled.prefix(count))
        return selected.enumerated().map { (index, item) in
            DailyTask(
                title: item.0,
                targetDate: date,
                xpReward: 15 + (index * 5),
                nicheObject: nil,
                status: .pending,
                category: item.1
            )
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, targetDate, completedDate, xpReward
        case nicheObject = "niche"
        case status, category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        targetDate = try container.decode(Date.self, forKey: .targetDate)
        completedDate = try container.decodeIfPresent(Date.self, forKey: .completedDate)
        xpReward = try container.decodeIfPresent(Int.self, forKey: .xpReward) ?? 10
        nicheObject = try container.decodeIfPresent(Niche.self, forKey: .nicheObject)
        let statusString = try container.decodeIfPresent(String.self, forKey: .status)
        status = statusString.flatMap { TaskStatus(rawValue: $0) } ?? .pending
        let categoryString = try container.decodeIfPresent(String.self, forKey: .category)
        category = categoryString.flatMap { TaskCategory(rawValue: $0) } ?? .quick
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(targetDate, forKey: .targetDate)
        try container.encodeIfPresent(completedDate, forKey: .completedDate)
        try container.encode(xpReward, forKey: .xpReward)
        try container.encodeIfPresent(nicheObject, forKey: .nicheObject)
        try container.encode(status.rawValue, forKey: .status)
        try container.encode(category.rawValue, forKey: .category)
    }
}