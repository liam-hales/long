import Foundation
import LucideSwift

/// Describes the options the user can
/// choose from to reschedule a task
enum TaskReschedule: CaseIterable, Identifiable {
  case today
  case tomorrow
  case nextWeek
  case anytime

  var id: Self {
    self
  }

  /// Describes the task
  /// reschedule title
  var title: String {
    switch self {
      case .today: "Today"
      case .tomorrow: "Tomorrow"
      case .nextWeek: "Next Week"
      case .anytime: "Anytime"
    }
  }

  /// Describes the task
  /// reschedule icon
  var icon: LucideIconName {
    switch self {
      case .today: .sun
      case .tomorrow: .sunrise
      case .nextWeek: .calendarChevronsRight
      case .anytime: .rotateCwClock
    }
  }

  /// The due date the task is moved to, or
  /// `nil` if it can be completed anytime
  var dueDate: Date? {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: .now)

    switch self {
      case .today:
        return today

      case .tomorrow:
        return calendar.date(byAdding: .day, value: 1, to: today)

      case .nextWeek:
        return calendar.dateInterval(of: .weekOfYear, for: today)?.end

      case .anytime:
        return nil
    }
  }
}
