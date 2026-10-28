import Foundation
import SwiftData

/// Describes a task sheet the user
/// can create to group tasks
@Model
final class TaskSheetModel: Identifiable {

  @MainActor
  private static var _undoManagers: [TaskSheetModel.ID: TaskSheetUndoManager] = [:]

  private(set) var name: String = ""

  @Relationship(
    deleteRule: .cascade,
    inverse: \TaskModel.sheet
  )
  var tasks: [TaskModel] = []

  private(set) var createDate: Date = Date.now
  private(set) var updateDate: Date = Date.now

  /// The undo manager used to undo and redo
  /// changes made to the task sheet and its tasks
  @MainActor
  var undoManager: TaskSheetUndoManager {

    // Check if there is an existing undo
    // manager first before creating a new one
    if let manager = Self._undoManagers[self.id] {
      return manager
    }

    let newManager = TaskSheetUndoManager()
    Self._undoManagers[self.id] = newManager

    return newManager
  }

  /// The most recent date calculated based on its own
  /// `updateDate` or any of its tasks `updateDate`
  var activityDate: Date {
    self.tasks.reduce(self.updateDate) { date, task in
      max(date, task.updateDate)
    }
  }

  /// The number of active tasks assigned to
  /// the sheet that are yet to be completed
  var activeCount: Int {
    self.tasks.count { task in task.isCompleted == false }
  }

  /// The number of overdue tasks
  /// that are assigned to the sheet
  var overdueCount: Int {
    self.tasks.count { task in
      (
        task.isCompleted == false &&
        task.schedule == .overdue
      )
    }
  }

  /// The number of tasks due today
  /// that are assigned to the sheet
  var todayCount: Int {
    self.tasks.count { task in
      (
        task.isCompleted == false &&
        task.schedule == .today
      )
    }
  }

  /// Initialises a new task sheet
  /// with a given `name`
  init(name: String) {
    self.name = name
    self.tasks = []
    self.createDate = .now
    self.updateDate = .now
  }

  /// Used to rename the task
  /// sheet to a given `name`
  @MainActor
  func rename(to name: String) -> Void {
    let oldName = self.name

    self.name = name

    // Set the name to the old value
    // if the user chooses to undo
    self._registerUpdate {
      self.rename(to: oldName)
    }
  }

  /// Used to assign the given `tasks` to the
  /// sheet and insert them so they persist
  @MainActor
  func addTasks(_ tasks: [TaskModel]) -> Void {
    tasks.forEach { task in

      // Assign each task to the sheet and insert
      // it so it only persists once added
      task.assign(to: self)
      self.modelContext?.insert(task)
    }

    // Remove the added tasks
    // if the user chooses to undo
    self._registerUpdate {
      self.removeTasks(tasks)
    }

    // Immediately save so
    // the data persists
    try? self.modelContext?.save()
  }

  /// Used to delete the given `tasks`
  /// so they are removed from the sheet
  @MainActor
  func removeTasks(_ tasks: [TaskModel]) -> Void {

    // Copy the tasks before deleting them so they
    // can be re added if the user decides to undo
    let copies = tasks.map { task in
      TaskModel(
        title: task.title,
        dueDate: task.dueDate
      )
    }

    tasks.forEach { task in
      self.modelContext?.delete(task)
    }

    // Add the task copies back
    // if the user chooses to undo
    self._registerUpdate {
      self.addTasks(copies)
    }

    // Immediately save so the
    // data removal persists
    try? self.modelContext?.save()
  }

  /// Used to set the update date and register
  /// the undo with the task sheet undo manager
  @MainActor
  private func _registerUpdate(undo: @escaping () -> Void) -> Void {
    self.updateDate = .now
    self.undoManager.registerUndo(withTarget: self) { _ in
      undo()
    }
  }
}
