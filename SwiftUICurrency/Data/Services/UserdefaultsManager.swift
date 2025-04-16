import Foundation

final class UserDefaultsManager {
    
    // MARK: - Properties
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func finishedOnboarding() -> Bool {
        return userDefaults.bool(forKey: AppConstants.UserDefaultsKey.finishedOnboarding)
    }
    
    func setHasFinishedOnboarding(_ value: Bool) {
        userDefaults.set(value, forKey: AppConstants.UserDefaultsKey.finishedOnboarding)
    }
    
    func markInitialFetchDone() {
        UserDefaults.standard.set(true, forKey: AppConstants.UserDefaultsKey.hasPerformedInitialFetch)
    }
    
    func hasDoneInitialFetch() -> Bool {
        UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKey.hasPerformedInitialFetch)
    }
}
