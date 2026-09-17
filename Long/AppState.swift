import Foundation

/// Used to store non-persistent
// state for the entire app
@Observable
final class AppState {
  var taskFilter: TaskFilter;

  init() {
    self.taskFilter = .date;
  }
}
