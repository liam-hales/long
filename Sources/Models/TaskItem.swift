import Foundation
import SwiftData

/// Describes a single task item
/// the user can create
@Model
final class TaskItem: Identifiable {
  
  /// Describes the different statuses a
  /// task item can be in at any given time
  enum TaskStatus: String {
    case overdue;
    case today;
    case scheduled;
    case unscheduled;
    case completed;
  }
  
  var title: String = "";
  var dueDate: Date?;
  var completedDate: Date?;
  var isArchived: Bool = false;
  var sheet: TaskSheetItem;

  private(set) var createDate: Date = Date.now;
  private(set) var updateDate: Date = Date.now;
  
  /// Calculates the task status based on its
  /// `dueDate` and `completedDate` data
  var status: TaskStatus {
    if (self.completedDate != nil) {
      return .completed;
    }
    
    // Check if the task has a due date, if not then the
    // task can be completed at anytime and is unscheduled
    guard let dueDate = self.dueDate else {
      return .unscheduled;
    }

    // A task due at any point today is treated
    // as something that needs completing today
    if (Calendar.current.isDateInToday(dueDate)) {
      return .today;
    }

    return (dueDate < .now)
      ? .overdue
      : .scheduled;
  }
    
  /// Initialises a new task with a given `sheet`,
  /// `title` and optional `dueDate`
  init(
    sheet: TaskSheetItem,
    title: String,
    dueDate: Date? = nil
  ) {
    self.title = title;
    self.dueDate = dueDate;
    self.isArchived = false;
    self.sheet = sheet;
    self.createDate = .now;
    self.updateDate = .now;
  }
}
