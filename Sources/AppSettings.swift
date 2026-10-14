import Foundation
import Observation

/// Used to store the app settings and
/// persist their values in `UserDefaults`
@MainActor
@Observable
final class AppSettings {
  private static let _appearanceKey = "appearance"

  private let _storage: UserDefaults

  /// The preferred app
  /// appearance setting
  var appearance: AppAppearance {
    didSet {
      self._storage.set(self.appearance.rawValue, forKey: Self._appearanceKey)
    }
  }

  /// Initialises the `AppSettings` with the values stored in
  /// `UserDefaults` or their defaults if non have been set
  init() {
    let storage = UserDefaults.standard

    self._storage = storage
    self.appearance = AppAppearance(
      rawValue: storage.string(forKey: Self._appearanceKey) ?? ""
    ) ?? .system
  }
}
