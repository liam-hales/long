import LucideSwift

/// Describes all ways the user
/// can filter their tasks
enum TaskFilter: CaseIterable, Identifiable {
  case all;
  case scheduled;
  case unscheduled;
    
  var id: Self {
    self;
  }
  
  /// Describes the task filter title
  var title: String {
    switch self {
      case .all: "All";
      case .scheduled: "Scheduled";
      case .unscheduled: "Unscheduled";
    }
  }
  
  /// Describes the task filter icon
  var icon: LucideIconName {
    switch self {
      case .all: .listCheck;
      case .scheduled: .calendarCheck2;
      case .unscheduled: .calendarX2;
    }
  }
}
