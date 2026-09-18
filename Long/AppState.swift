import Foundation

/// Used to store non-persistent
// state for the entire app
@Observable
final class AppState {
  var taskFilter: TaskFilter;
  var status: AppStatus;
  
  var isCreatingTask: Bool {
    get {
      return (self.status == .creatingTask)
    }
    set {
      self.status = (newValue == true)
        ? .creatingTask
        : .idle
    }
  }

  init() {
    self.taskFilter = .date;
    self.status = .idle;
  }
}
