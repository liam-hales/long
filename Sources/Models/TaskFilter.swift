import LucideSwift

/// Describes all ways the user
/// can filter their tasks
enum TaskFilter: CaseIterable, Identifiable {
  case date;
  case category;
    
  var id: Self {
    self;
  }
  
  /// Describes the task filter title
  var title: String {
    switch self {
      case .date: "Date";
      case .category: "Category";
    }
  }
  
  /// Describes the task filter icon
  var icon: LucideIconName {
    switch self {
      case .date: .calendarDays;
      case .category: .tags;
    }
  }
}
