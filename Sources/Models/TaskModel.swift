import Foundation
import SwiftData

/// Describes a single task
/// the user can create
@Model
final class TaskModel: Identifiable {

  /// Describes the different statuses a
  /// task can be in at any given time
  enum Status {
    case overdue
    case today
    case scheduled
    case unscheduled
    case completed
  }

  private(set) var title: String = ""
  private(set) var dueDate: Date?
  private(set) var completedDate: Date?
  private(set) var isArchived: Bool = false
  private(set) var sheet: TaskSheetModel

  private(set) var createDate: Date = Date.now
  private(set) var updateDate: Date = Date.now

  /// Calculates the task status based on its
  /// `dueDate` and `completedDate` data
  var status: Status {
    if (self.completedDate != nil) {
      return .completed
    }

    // Check if the task has a due date, if not then the
    // task can be completed at anytime and is unscheduled
    guard let dueDate = self.dueDate else {
      return .unscheduled
    }

    // A task due at any point today is treated
    // as something that needs completing today
    if (Calendar.current.isDateInToday(dueDate)) {
      return .today
    }

    return (dueDate < .now)
      ? .overdue
      : .scheduled
  }

  /// Formats the `dueDate` into a human
  /// readable format relative to today
  var dueText: String {
    guard let dueDate = self.dueDate else {
      return "No due date"
    }

    let days = Calendar.current.dateComponents(
      [.day],
      from: Calendar.current.startOfDay(for: .now),
      to: dueDate
    ).day ?? 0

    // Dates more than a week either side
    // of today are shown as the full date
    if (abs(days) > 7) {
      return dueDate.formatted(date: .abbreviated, time: .omitted)
    }

    // Return the date in
    // a relative format
    return dueDate.formatted(
      Date.RelativeFormatStyle(
        allowedFields: [.day],
        presentation: .named,
        capitalizationContext: .beginningOfSentence
      )
    )
  }

  /// Initialises a new task with a given `sheet`,
  /// `title` and optional `dueDate`
  init(
    sheet: TaskSheetModel,
    title: String,
    dueDate: Date? = nil
  ) {
    self.title = title
    self.dueDate = dueDate
    self.isArchived = false
    self.sheet = sheet
    self.createDate = .now
    self.updateDate = .now
  }

  /// Used to toggle the task between
  /// active and completed
  func toggleCompleted() -> Void {
    self.updateDate = .now

    // Set the completed date to either the current
    // date or `nil` depending on its current value
    self.completedDate = (self.completedDate == nil)
      ? .now
      : nil
  }
}
