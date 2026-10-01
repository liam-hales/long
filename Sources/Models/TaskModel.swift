import Foundation
import SwiftData

/// Describes a single task
/// the user can create
@Model
final class TaskModel: Identifiable {

  /// Describes where a task sits in
  /// the schedule based on its due date
  enum Schedule {
    case overdue
    case today
    case scheduled
    case unscheduled
  }

  private(set) var title: String = ""
  private(set) var dueDate: Date?
  private(set) var completedDate: Date?
  private(set) var sheet: TaskSheetModel

  private(set) var createDate: Date = Date.now
  private(set) var updateDate: Date = Date.now

  /// Calculates where the task sits in
  /// the schedule based on its `dueDate`
  var schedule: Schedule {

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

  /// Determines whether the task has
  /// been completed or not
  var isCompleted: Bool {
    self.completedDate != nil
  }

  /// Determines whether the task was completed
  /// long enough ago to be considered settled
  var isSettled: Bool {
    guard let completedDate = self.completedDate else {
      return false
    }

    // Define the delay amount (30 seconds) and add it to the
    // completed date to have a new date to compare against
    let delay: TimeInterval = 30
    let delayDate = completedDate.addingTimeInterval(delay)

    return (delayDate <= .now)
  }

  /// The task subtitle built from the most relevant date formatted
  /// into a human readable format relative to today
  var subtitle: String {

    // If the task has a completed date
    // then use this to build the subtitle
    if let completedDate = self.completedDate {
      let text = self._relativeText(
        for: completedDate,
        includeTime: true
      )

      return "Completed \(text)"
    }

    // If the task has a due date then
    // use this to build the subtitle
    if let dueDate = self.dueDate {
      let text = self._relativeText(
        for: dueDate,
        includeTime: false
      )

      return "Due \(text)"
    }

    return "No due date"
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

  /// Formats a given `date` into a human
  /// readable format relative to today
  private func _relativeText(
    for date: Date,
    includeTime: Bool = false
  ) -> String {
    let calendar = Calendar.current

    // Extract the number of days it has been
    // from today since the given date
    let days = calendar.dateComponents(
      [.day],
      from: calendar.startOfDay(for: .now),
      to: date
    ).day ?? 0

    let relativeStyle = Date.RelativeFormatStyle(
      allowedFields: [.day],
      presentation: .named,
      capitalizationContext: .middleOfSentence
    )

    // Dates more than a week either side of today are shown as
    // the full date, otherwise they're shown relative
    let dateText = (abs(days) > 7)
      ? date.formatted(
        date: .abbreviated,
        time: .omitted
      )
      : date.formatted(relativeStyle)

    // If the text should not include the time then
    // just return the date text as is
    if (includeTime == false) {
      return dateText
    }

    let timeText = date.formatted(
      date: .omitted,
      time: .shortened
    )

    return "\(dateText) at \(timeText)"
  }
}
