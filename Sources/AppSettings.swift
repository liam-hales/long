import Foundation
import Observation

/// Used to store the app settings and
/// persist their values in `UserDefaults`
@Observable
final class AppSettings {
  private static let _preferredNameKey = "preferredName"
  private static let _appearanceKey = "appearance"
  private static let _dateFormatKey = "dateFormat"
  private static let _isReviewEnabledKey = "isReviewEnabled"
  private static let _taskSheetSortKey = "taskSheetSort"
  private static let _isOverdueNotificationEnabledKey = "isOverdueNotificationEnabled"
  private static let _isDueTodayNotificationEnabledKey = "isDueTodayNotificationEnabled"
  private static let _notificationTimeKey = "notificationTime"

  private let _storage: UserDefaults

  /// The name the user prefers
  /// to be greeted by
  var preferredName: String {
    didSet {
      self._storage.set(self.preferredName, forKey: Self._preferredNameKey)
    }
  }

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

  /// The preferred order to
  /// sort the task sheets
  var taskSheetSort: TaskSheetSort {
    didSet {
      self._storage.set(self.taskSheetSort.rawValue, forKey: Self._taskSheetSortKey)
    }
  }

  /// Whether a summary notification is
  /// sent for tasks that are overdue
  var isOverdueNotificationEnabled: Bool {
    didSet {
      self._storage.set(self.isOverdueNotificationEnabled, forKey: Self._isOverdueNotificationEnabledKey)
    }
  }

  /// Whether a summary notification is
  /// sent for tasks that are due today
  var isDueTodayNotificationEnabled: Bool {
    didSet {
      self._storage.set(self.isDueTodayNotificationEnabled, forKey: Self._isDueTodayNotificationEnabledKey)
    }
  }

  /// The time of day the summary
  /// notifications are sent
  var notificationTime: Date {
    didSet {
      self._storage.set(self.notificationTime, forKey: Self._notificationTimeKey)
    }
  }

  /// Initialises the `AppSettings` with the values stored in
  /// `UserDefaults` or their defaults if non have been set
  init() {
    let storage = UserDefaults.standard
    let calendar = Calendar.current

    let defaultNotificationTime = calendar.date(
      bySettingHour: 8,
      minute: 0,
      second: 0,
      of: .now
    ) ?? .now

    self._storage = storage
    self.preferredName = storage.string(forKey: Self._preferredNameKey) ?? ""

    self.appearance = AppAppearance(
      rawValue: storage.string(forKey: Self._appearanceKey) ?? ""
    ) ?? .system

    self.dateFormat = DateFormat(
      rawValue: storage.string(forKey: Self._dateFormatKey) ?? ""
    ) ?? .relative

    self.isReviewEnabled = (
      storage.object(forKey: Self._isReviewEnabledKey) as? Bool
    ) ?? true

    self.taskSheetSort = TaskSheetSort(
      rawValue: storage.string(forKey: Self._taskSheetSortKey) ?? ""
    ) ?? .lastActive

    self.isOverdueNotificationEnabled = (
      storage.object(forKey: Self._isOverdueNotificationEnabledKey) as? Bool
    ) ?? true

    self.isDueTodayNotificationEnabled = (
      storage.object(forKey: Self._isDueTodayNotificationEnabledKey) as? Bool
    ) ?? true

    self.notificationTime = (
      storage.object(forKey: Self._notificationTimeKey) as? Date
    ) ?? defaultNotificationTime
  }
}
