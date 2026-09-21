import LucideSwift

/// Describes the different modes
/// the `TaskInputView` can be in
enum TaskInputMode: CaseIterable, Identifiable {
  case manual;
  case auto;
  
  var id: Self {
    self;
  }
  
  /// Describes the task
  /// input mode title
  var title: String {
    switch self {
      case .manual: "Manual";
      case .auto: "Auto";
    }
  }
  
  /// Describes the task
  /// input mode icon
  var icon: LucideIconName {
    switch self {
      case .manual: .notebookPen;
      case .auto: .pencilSparkles;
    }
  }
}
