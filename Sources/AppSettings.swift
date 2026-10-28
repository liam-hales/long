import Foundation
import Observation

/// Used to store the app settings and
/// persist their values in `UserDefaults`
@Observable
final class AppSettings {
  private static let _appearanceKey = "appearance"
  private static let _dateFormatKey = "dateFormat"
  private static let _isReviewEnabledKey = "isReviewEnabled"
  private static let _preferredNameKey = "preferredName"

  private let _storage: UserDefaults

  /// The preferred app
  /// appearance setting
  var appearance: AppAppearance {
    didSet {
      self._storage.set(self.appearance.rawValue, forKey: Self._appearanceKey)
    }
  }

  /// The preferred date
  /// format setting
  var dateFormat: DateFormat {
    didSet {
      self._storage.set(self.dateFormat.rawValue, forKey: Self._dateFormatKey)
    }
  }

  /// Whether captured tasks are presented
  /// for review before they are added
  var isReviewEnabled: Bool {
    didSet {
      self._storage.set(self.isReviewEnabled, forKey: Self._isReviewEnabledKey)
    }
  }

  /// The name the user prefers
  /// to be greeted by
  var preferredName: String {
    didSet {
      self._storage.set(self.preferredName, forKey: Self._preferredNameKey)
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

    self.dateFormat = DateFormat(
      rawValue: storage.string(forKey: Self._dateFormatKey) ?? ""
    ) ?? .relative

    self.isReviewEnabled = (
      storage.object(forKey: Self._isReviewEnabledKey) as? Bool
    ) ?? true

    self.preferredName = storage.string(forKey: Self._preferredNameKey) ?? ""
  }
}
