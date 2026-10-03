import Foundation
import SwiftData
import SwiftUI

/// Used to store state for
/// the entire app
@MainActor
@Observable
final class AppState {

  /// Describes what the user has
  /// currently selected for navigation
  enum NavSelection: Hashable {
    case taskSheet(_ id: TaskSheetModel.ID)
  }

  /// Describes which modal the user
  /// currently has presented
  enum ModalSelection: Identifiable {
    case editTaskSheet
    case editTask
    case reviewTasks
    case settings

    var id: Self {
      self
    }
  }

  private let _context: ModelContext
  private let _captureService: TaskCaptureService

  var navVisibility: NavigationSplitViewVisibility
  var navSelection: NavSelection?
  var modalSelection: ModalSelection?
  var taskFocus: TaskFocus
  var taskInput: String
  var pendingTasks: [TaskModel]

  /// The currently selected task sheet
  /// if the user has one selected
  var selectedTaskSheet: TaskSheetModel? {
    guard case .taskSheet(let id) = self.navSelection else {
      return nil
    }

    // Define the descriptor to fetch
    // the task sheet via its ID
    let descriptor = FetchDescriptor<TaskSheetModel>(
      predicate: #Predicate { sheet in
        sheet.id == id
      }
    )

    return try? self._context
      .fetch(descriptor)
      .first
  }

  /// Initialises the `AppState` with a given model context
  /// and the service used to capture tasks
  init(
    context: ModelContext,
    captureService: TaskCaptureService
  ) {
    self._context = context
    self._captureService = captureService

    self.navSelection = nil
    self.navVisibility = .doubleColumn
    self.modalSelection = nil
    self.taskFocus = .all
    self.taskInput = ""
    self.pendingTasks = []
  }

  /// Used to create and save a new
  /// task sheet with a given `name`
  func createTaskSheet(name: String) -> Void {
    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)

    // Check if the trimmed name
    // is empty and if so return
    if trimmed.isEmpty == true {
      return
    }

    let newSheet = TaskSheetModel(name: trimmed)

    // Insert and immediately save the
    // new task sheet so it persists
    self._context.insert(newSheet)
    try? self._context.save()

    // Set the navigation selection state
    // to the new task sheet
    self.navSelection = .taskSheet(newSheet.id)
  }

  /// Used to delete a given task `sheet`
  /// and clear any state referencing it
  func deleteTaskSheet(_ sheet: TaskSheetModel) -> Void {

    // Clear the navigation selection if the user
    // is viewing the task sheet being deleted
    if (self.navSelection == .taskSheet(sheet.id)) {
      self.navSelection = nil
    }

    // Delete and immediately save so the removal
    // persists, tasks will cascade delete
    self._context.delete(sheet)
    try? self._context.save()
  }

  /// Used to capture tasks from the task input
  /// and present them for the user to review
  func captureTasks() async throws -> Void {
    let capturedTasks = try await self._captureService.capture(from: self.taskInput)

    // Set the pending tasks and
    // model selection state
    self.pendingTasks = capturedTasks
    self.modalSelection = .reviewTasks
  }

  /// Used to add the pending tasks to the selected
  /// task sheet then clear the task input
  func addPendingTasks() -> Void {
    guard let sheet = self.selectedTaskSheet else {
      return
    }

    for task in self.pendingTasks {

      // Assign each pending task to the sheet and insert
      // it so it only persists once confirmed
      task.assign(to: sheet)
      self._context.insert(task)
    }

    // Immediately save so the
    // data persists
    try? self._context.save()

    self.pendingTasks = []
    self.taskInput = ""
  }
}
