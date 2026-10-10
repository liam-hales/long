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

  /// Describes the status the task is in during
  /// the review process after being captured
  enum ReviewStatus {
    case confirmed
    case discarded
    case added
  }

  private(set) var title: String = ""
  private(set) var dueDate: Date?
  private(set) var completedDate: Date?
  private(set) var sheet: TaskSheetModel?

  private(set) var createDate: Date = Date.now
  private(set) var updateDate: Date = Date.now

  @Transient
  private var _reviewStatus: ReviewStatus = .added

  /// Describes the status the task is in during
  /// the review process after being captured
  private(set) var reviewStatus: ReviewStatus {
    get {
      self.access(keyPath: \.reviewStatus)
      return self._reviewStatus
    }
    set {
      self.withMutation(keyPath: \.reviewStatus) {
        self._reviewStatus = newValue
      }
    }
  }

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

    // Define the delay amount (10 seconds) and add it to the
    // completed date to have a new date to compare against
    let delay: TimeInterval = 10
    let delayDate = completedDate.addingTimeInterval(delay)

    return (delayDate <= .now)
  }

  /// The task subtitle built from the most relevant date formatted
  /// into a human readable format relative to today
  var subtitle: String {

    // If the task has a completed date
    // then use this to build the subtitle
    if let completedDate = self.completedDate {
      return "Completed \(completedDate.relativeText(includeTime: true))"
    }

    // If the task has a due date then
    // use this to build the subtitle
    if let dueDate = self.dueDate {
      return "Due \(dueDate.relativeText(includeTime: false))"
    }

    return "No due date"
  }

  /// Initialises a new task with a given
  /// `title` and optional `dueDate`
  init(
    title: String,
    dueDate: Date? = nil
  ) {
    self.title = title
    self.dueDate = dueDate
    self.createDate = .now
    self.updateDate = .now
    self._reviewStatus = .confirmed
  }

  /// Used to assign the task
  /// to a given task sheet
  func assign(to sheet: TaskSheetModel) -> Void {
    self.updateDate = .now

    // Assign the task to the given sheet and
    // set the review status to added
    self.sheet = sheet
    self.reviewStatus = .added
  }

  /// Used to toggle the task between confirmed
  /// and discarded while it is being reviewed
  func toggleConfirmed() -> Void {
    self.reviewStatus = (self.reviewStatus == .confirmed)
      ? .discarded
      : .confirmed
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
