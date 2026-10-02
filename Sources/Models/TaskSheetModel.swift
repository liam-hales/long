import Foundation
import SwiftData

/// Describes a task sheet the user
/// can create to group tasks
@Model
final class TaskSheetModel: Identifiable {
  private(set) var name: String = ""

  @Relationship(
    deleteRule: .cascade,
    inverse: \TaskModel.sheet
  )
  var tasks: [TaskModel] = []

  private(set) var createDate: Date = Date.now
  private(set) var updateDate: Date = Date.now

  /// The most recent date calculated based on its own
  /// `updateDate` or any of its tasks `updateDate`
  var activityDate: Date {
    self.tasks.reduce(self.updateDate) { date, task in
      max(date, task.updateDate)
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
  func rename(to name: String) -> Void {
    self.name = String(name.prefix(32))
    self.updateDate = .now
  }
}
