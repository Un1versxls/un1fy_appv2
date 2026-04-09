import Foundation

struct UserSettings: Codable, Equatable {
    var dailyReminderEnabled: Bool
    var soundEnabled: Bool
    var hapticEnabled: Bool
    
    init(
        dailyReminderEnabled: Bool = true,
        soundEnabled: Bool = true,
        hapticEnabled: Bool = true
    ) {
        self.dailyReminderEnabled = dailyReminderEnabled
        self.soundEnabled = soundEnabled
        self.hapticEnabled = hapticEnabled
    }
}
