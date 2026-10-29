import LucideSwift

/// Describes the different ways the user
/// can choose to sort their task sheets
enum TaskSheetSort: String, CaseIterable, Identifiable {
  case lastActive = "lastActive"
  case name = "name"
  case created = "created"

  var id: Self {
    self
  }

  /// Describes the task
  /// sheet sort title
  var title: String {
    switch self {
      case .lastActive: "Last Active"
      case .name: "Name"
      case .created: "Created"
    }
  }

  /// Describes the task
  /// sheet sort icon
  var icon: LucideIconName {
    switch self {
      case .lastActive: .clock
      case .name: .arrowDownAZ
      case .created: .calendarPlus
    }
  }
}
