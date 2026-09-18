import Foundation
import SwiftData

/// Describes a single task item
/// the user can create
@Model
final class TaskItem: Identifiable {
  var title: String = "";
  var dueDate: Date?;
  var completedDate: Date?;
  var isArchived: Bool = false;

  private(set) var createDate: Date = Date.now;
  private(set) var updateDate: Date = Date.now;
    
  /// Initialises a new task with a given
  /// `title` and optional `dueDate`
  init(
    title: String,
    dueDate: Date? = nil
  ) {
    self.title = title;
    self.dueDate = dueDate;
    self.isArchived = false;
    self.createDate = .now;
    self.updateDate = .now;
  }
}
