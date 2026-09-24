import Foundation
import SwiftData

/// Used to store state for
/// the entire app
@Observable
final class AppState {
  private let _context: ModelContext;

  /// Describes what the user has
  /// currently selected for navigation
  enum NavSelection: Hashable {
    case taskSheet(_ id: TaskSheetItem.ID);
    case settings;
    case archived;
  }

  var navSelection: NavSelection?;
  var taskFilter: TaskFilter;

  /// The currently selected task sheet
  /// if the user has one selected
  var selectedTaskSheet: TaskSheetItem? {
    guard case .taskSheet(let id) = self.navSelection else {
      return nil;
    }

    // Define the descriptor to fetch
    // the task sheet item via its ID
    let descriptor = FetchDescriptor<TaskSheetItem>(
      predicate: #Predicate {
        $0.persistentModelID == id
      }
    );

    return try? self._context
      .fetch(descriptor)
      .first;
  }

  /// Initialises the `AppState` with a given
  /// model context for the task item
  init(context: ModelContext) {
    self._context = context;

    self.taskFilter = .all;
    self.navSelection = nil;
  }

  /// Used to create and save a
  /// new task with a give `title`
  func createTask(title: String) -> Void {
    self._createTask(title: title);
  }

  /// Used to create and save a new task
  /// with a given `title` and `dueDate`
  private func _createTask(title: String, dueDate: Date? = nil) -> Void {
    let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines);

    // Check if the trimmed title
    // is empty and if so return
    if (trimmed.isEmpty == true) {
      return;
    }

    // Make sure the user has
    // a task sheet selected
    guard let sheet = self.selectedTaskSheet else {
      return;
    }

    // Create the new task for the selected task sheet
    // with the trimmed title and due date
    let newTask = TaskItem(
      sheet: sheet,
      title: trimmed,
      dueDate: dueDate
    );

    // Insert and immediately save the
    // new task so it persists
    self._context.insert(newTask);
    try? self._context.save();
  }
}
