/// Describes the search scopes the user can
/// use to narrow their search results
enum TaskSearchScope: CaseIterable, Identifiable {
  case all
  case active
  case completed

  var id: Self {
    self
  }

  /// Describes the task
  /// search scope title
  var title: String {
    switch self {
      case .all: "All"
      case .active: "Active"
      case .completed: "Completed"
    }
  }

  /// Describes the tasks included
  /// in the search scope
  var tasksDescription: String {
    switch self {
      case .all: "tasks"
      case .active: "active tasks"
      case .completed: "completed tasks"
    }
  }
}
