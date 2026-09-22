import LucideSwift

/// Describes the different modes
/// the `TaskInputView` can be in
enum TaskInputMode: CaseIterable, Identifiable {
  case add;
  case capture;
  
  var id: Self {
    self;
  }
  
  /// Describes the task
  /// input mode title
  var title: String {
    switch self {
      case .add: "Add";
      case .capture: "Capture";
    }
  }
  
  /// Describes the task
  /// input mode icon
  var icon: LucideIconName {
    switch self {
      case .add: .listPlus;
      case .capture: .pencilSparkles;
    }
  }
}
