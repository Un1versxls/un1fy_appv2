import Foundation

final class StorageManager {
    static let shared = StorageManager()
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let appStateKey = "com.drive.appState"
    
    private init() {}
    
    func saveAppState(_ state: AppState) {
        do {
            let data = try encoder.encode(state)
            defaults.set(data, forKey: appStateKey)
            defaults.synchronize()
        } catch {
            print("Failed to save AppState: \(error)")
        }
    }
    
    func loadAppState() -> AppState? {
        guard let data = defaults.data(forKey: appStateKey) else { return nil }
        do {
            return try decoder.decode(AppState.self, from: data)
        } catch {
            print("Failed to load AppState: \(error)")
            return nil
        }
    }
}
