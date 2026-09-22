import Foundation
import SwiftData

/// Used to store state for
/// the entire app
@Observable
final class AppState {
  private let _context: ModelContext;
  
  /// Describes the different statuses
  /// the app can be in at any given time
  enum Status: String {
    case idle;
  }

  var status: Status;
  var taskFilter: TaskFilter;
  
  /// Initialises the `AppState` with a given
  /// model context for the task item
  init(context: ModelContext) {
    self._context = context;
    
    self.taskFilter = .all;
    self.status = .idle;
  }
  
  /// Used to create a task
  /// with a give `title`
  func createTask(title: String) -> Void {
    self._createTask(title: title);
  }
  
  /// Used to create and save a new task item
  /// with a given `title` and `dueDate`
  private func _createTask(title: String, dueDate: Date? = nil) -> Void {
    let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines);
    
    // Check if the trimmed title
    // is empty and if so return
    if (trimmed.isEmpty == true) {
      return;
    }

    // Create the new task
    // with the trimmed title
    let newTask = TaskItem(
      title: trimmed,
      dueDate: dueDate
    );

    // Insert and immediately save the
    // new task so it persists
    self._context.insert(newTask);
    try? self._context.save();
  }
}
