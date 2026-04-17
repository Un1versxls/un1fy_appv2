import Foundation

struct AppPlan: Codable, Identifiable, Equatable {
    let id: UUID
    let tier: PlanTier
    let name: String
    let price: Double
    let durationDays: Int?
    let features: [String]
    var isActive: Bool
    let expirationDate: Date?
    
    init(
        id: UUID = UUID(),
        tier: PlanTier,
        name: String,
        price: Double,
        durationDays: Int? = nil,
        features: [String],
        isActive: Bool = false,
        expirationDate: Date? = nil
    ) {
        self.id = id
        self.tier = tier
        self.name = name
        self.price = price
        self.durationDays = durationDays
        self.features = features
        self.isActive = isActive
        self.expirationDate = expirationDate
    }
    
    var description: String {
        switch tier {
        case .free: return "Perfect for getting started"
        case .pro: return "For serious creators"
        case .elite: return "Maximum power and features"
        }
    }
    
    var priceString: String {
        if price == 0 {
            return "Free"
        }
        return String(format: "$%.2f/month", price)
    }
    
    var taskLimitText: String {
        switch tier {
        case .free: return "2 tasks/day"
        case .pro: return "Unlimited"
        case .elite: return "Unlimited + AI"
        }
    }
    
    var isPopular: Bool {
        tier == .pro
    }
    
    static let free = AppPlan(
        tier: .free,
        name: "Free",
        price: 0.0,
        features: [
            "2 Habit tracks",
            "Basic analytics",
            "Community access"
        ],
        isActive: true
    )
    
    static let pro = AppPlan(
        tier: .pro,
        name: "Pro",
        price: 9.99,
        durationDays: 30,
        features: [
            "Unlimited habit tracks",
            "Advanced analytics",
            "Priority support",
            "Premium niches",
            "Custom reminders",
            "Export data"
        ]
    )
    
    static let elite = AppPlan(
        tier: .elite,
        name: "Elite",
        price: 29.99,
        durationDays: 30,
        features: [
            "Everything in Pro",
            "5x Points Multiplier",
            "Exclusive Niches",
            "Priority Support",
            "Advanced Analytics",
            "AI Coach"
        ]
    )
    
    static let allPlans: [AppPlan] = [.free, .pro, .elite]
    
    enum CodingKeys: String, CodingKey {
        case id, tier, name, price, durationDays, features, isActive, expirationDate, type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        durationDays = try container.decodeIfPresent(Int.self, forKey: .durationDays)
        features = try container.decode([String].self, forKey: .features)
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        expirationDate = try container.decodeIfPresent(Date.self, forKey: .expirationDate)
        
        // Decode tier with migration support
        if let tierString = try container.decodeIfPresent(String.self, forKey: .tier) {
            tier = PlanTier(rawValue: tierString) ?? .free
        } else if let oldTypeString = try container.decodeIfPresent(String.self, forKey: .type) {
            switch oldTypeString {
            case "free": tier = .free
            case "pro": tier = .pro
            case "basic": tier = .free
            case "lifetime": tier = .elite
            default: tier = .free
            }
        } else {
            tier = .free
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(tier.rawValue, forKey: .tier)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
        try container.encodeIfPresent(durationDays, forKey: .durationDays)
        try container.encode(features, forKey: .features)
        try container.encode(isActive, forKey: .isActive)
        try container.encodeIfPresent(expirationDate, forKey: .expirationDate)
    }
}