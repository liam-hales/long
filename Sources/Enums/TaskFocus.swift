import LucideSwift

/// Describes all the ways the user
/// can focus on their tasks
enum TaskFocus: CaseIterable, Identifiable {
  case all
  case today
  case overdue
  case scheduled
  case unscheduled
  case completed

  var id: Self {
    self
  }

  /// Describes the task focus title
  var title: String {
    switch self {
      case .all: "All"
      case .today: "Today"
      case .overdue: "Overdue"
      case .scheduled: "Scheduled"
      case .unscheduled: "Unscheduled"
      case .completed: "Completed"
    }
  }

  /// Describes the task focus icon
  var icon: LucideIconName {
    switch self {
      case .all: .listCheck
      case .today: .sun
      case .overdue: .calendarClock
      case .scheduled: .calendarCheck2
      case .unscheduled: .calendarX2
      case .completed: .check
    }
  }
}
