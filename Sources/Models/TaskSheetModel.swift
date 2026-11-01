import Foundation
import SwiftData

/// Describes a task sheet the user
/// can create to group tasks
@Model
final class TaskSheetModel: Identifiable, BaseModel {

  @MainActor
  private static var _undoManagers: [TaskSheetModel.ID: TaskSheetUndoManager] = [:]

  private(set) var name: String = ""

  @Relationship(
    deleteRule: .cascade,
    inverse: \TaskModel.sheet
  )
  var tasks: [TaskModel] = []

  private(set) var createDate: Date = Date.now
  var updateDate: Date = Date.now

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

  /// Used to update the task
  /// sheet with a given `name`
  @MainActor
  func update(name: String) -> Void {
    self._update(\.name, to: name)
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
    
    self._recordChange {
      self.removeTasks(tasks)
    }

    // Immediately save so
    // the data persists
    try? self.modelContext?.save()
  }

  /// Used to unassign the given `tasks` so they are removed
  /// from the sheet, they're deleted on the next app launch
  @MainActor
  func removeTasks(_ tasks: [TaskModel]) -> Void {

    // Unassign the tasks rather than deleting them so the same
    // tasks are added back if the user chooses to undo
    tasks.forEach { task in
      task.unassign()
    }
    
    self._recordChange {
      self.addTasks(tasks)
    }

    // Immediately save so the
    // task removal persists
    try? self.modelContext?.save()
  }

  /// Used to complete all of the tasks
  /// in the sheet that are still active
  @MainActor
  func completeAllTasks() -> Void {
    self.tasks
      .filter { task in task.isCompleted == false }
      .forEach { task in task.update(completedDate: .now) }
  }
}
