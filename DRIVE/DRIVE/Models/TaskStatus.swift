import Foundation

enum TaskStatus: String, Codable, CaseIterable {
    case pending, completed, skipped
}
