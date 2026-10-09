import LucideSwift

/// Describes all the ways the user can filter their tasks,
/// used for both focusing on and sectioning tasks
enum TaskFilter: CaseIterable, Identifiable {
  case all
  case overdue
  case today
  case scheduled
  case unscheduled
  case completed

  var id: Self {
    self
  }

  /// Describes the task
  /// filter title
  var title: String {
    switch self {
      case .all: "All"
      case .overdue: "Overdue"
      case .today: "Today"
      case .scheduled: "Scheduled"
      case .unscheduled: "Anytime"
      case .completed: "Completed"
    }
  }

  /// Describes the task
  /// filter icon
  var icon: LucideIconName {
    switch self {
      case .all: .listCheck
      case .overdue: .clockAlert
      case .today: .sun
      case .scheduled: .calendarCheck2
      case .unscheduled: .rotateCwClock
      case .completed: .check
    }
  }
}
