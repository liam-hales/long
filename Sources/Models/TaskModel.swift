import Foundation
import SwiftData

/// Describes a single task
/// the user can create
@Model
final class TaskModel: Identifiable, BaseModel {

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
  var updateDate: Date = Date.now

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
    self.schedule(at: .now)
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

  /// The undo manager of the task sheet the task is
  /// assigned to, which is required to record changes
  @MainActor
  var undoManager: TaskSheetUndoManager {
    guard let sheet = self.sheet else {
      fatalError("A task must be assigned to a sheet in order to use its \"undoManager\"")
    }

    return sheet.undoManager
  }

  /// Used to calculate the task schedule
  /// for a given `date` based on its `dueDate`
  func schedule(at date: Date) -> Schedule {

    // Check if the task has a due date, if not then the
    // task can be completed at anytime and is unscheduled
    guard let dueDate = self.dueDate else {
      return .unscheduled
    }

    // A task due at any point on the day is treated
    // as something that needs completing that day
    if (Calendar.current.isDate(dueDate, inSameDayAs: date)) {
      return .today
    }

    return (dueDate < date)
      ? .overdue
      : .scheduled
  }

  /// The task subtitle built from the most relevant date formatted
  /// into a human readable format using the `dateFormat`
  func subtitle(dateFormat: DateFormat) -> String {

    // If the task has a completed date
    // then use this to build the subtitle
    if let completedDate = self.completedDate {
      return "Completed \(completedDate.text(dateFormat, includeTime: true))"
    }

    // If the task has a due date then
    // use this to build the subtitle
    if let dueDate = self.dueDate {
      return "Due \(dueDate.text(dateFormat, includeTime: false))"
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

  /// Used to update the task with
  /// a given `title` and `dueDate`
  @MainActor
  func update(
    title: String,
    dueDate: Date?
  ) -> Void {
    self._update(\.title, to: title)
    self._update(\.dueDate, to: dueDate)
  }

  /// Used to update the task with
  /// a given `completedDate`
  @MainActor
  func update(completedDate: Date?) -> Void {
    self._update(\.completedDate, to: completedDate)
  }

  /// Used to update the task with a given
  /// `reviewStatus` while it is being reviewed
  func update(reviewStatus: ReviewStatus) -> Void {
    self.reviewStatus = reviewStatus
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

  /// Used to unassign the task
  /// from its task sheet
  func unassign() -> Void {
    self.updateDate = .now
    self.sheet = nil
  }
}
