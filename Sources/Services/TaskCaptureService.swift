import DataDetection
import Foundation
import FoundationModels

/// Used to capture tasks from a users
/// input text using the on-device model
@MainActor
final class TaskCaptureService {

  /// Describes a single captured
  /// task the model should generate
  @Generable
  struct CapturedTask {

    @Guide(
      description:
        """
        A short, actionable title for the task written in sentence \
        case that starts with a verb, without any due date words
        """
    )
    let title: String

    @Guide(
      description:
        """
        When the task is due, rewritten as a simple date phrase such as...
          - "tomorrow"
          - "Friday"
          - "next Monday"
          - "in 3 days"
          - "October 12"

        Never work out the actual date yourself.
        Leave out if no due date is mentioned.
        """
    )
    let dueDateText: String?
  }

  private var _modelSession: LanguageModelSession?
  private let _instructions: String

  /// Initialises the `TaskCaptureService` with
  /// the model instructions
  init() {
    self._instructions =
    """
    Your purpose is to extract tasks from text the user has written, \
    in the order they appear.

    Rules:
      - Split text that mentions several things into separate tasks.
      - Only include tasks that are in the text, never invent new ones.
      - Group relevant tasks into one, for example "Buy milk, eggs and flour" should be one task
      - Dates always go in dueDateText and never in the title.

    Example:
      Text: "Book a dentist appointment tomorrow and put the bins out on Monday"
      Tasks:
        - title: "Book a dentist appointment", dueDateText: "tomorrow"
        - title: "Put the bins out", dueDateText: "Monday"

    The text may not include any tasks, which is fine and you can \
    just return an empty array.
    """
  }

  /// Used to initialise and prewarm
  /// the model session before use
  func startSession() {

    // Only start a model session if
    // one does not already exist
    if (self._modelSession != nil) {
      return
    }

    self._modelSession = .init(instructions: self._instructions)
    self._modelSession?.prewarm()
  }

  /// Used to capture tasks from a given `text` as
  /// unsaved pending tasks for the user to review
  func capture(from text: String) async throws -> [TaskModel] {

    // Make sure the on device model can be used,
    // throwing a specific error for each reason
    switch SystemLanguageModel.default.availability {
      case .available:
        break

      case .unavailable(.deviceNotEligible):
        throw TaskCaptureError.deviceNotSupported

      case .unavailable(.appleIntelligenceNotEnabled):
        throw TaskCaptureError.appleIntelligenceDisabled

      case .unavailable(.modelNotReady):
        throw TaskCaptureError.modelNotReady

      case .unavailable:
        throw TaskCaptureError.modelUnavailable
    }

    // Make sure the model session has
    // been started and prewarmed
    guard let session = self._modelSession else {
      throw TaskCaptureError.sessionNotStarted
    }

    // Clear the session so it can only
    // be used for one capture
    self._modelSession = nil

    // Use greedy sampling so the model always picks its
    // most likely output, making the extraction consistent
    let response = try await session.respond(
      to: text,
      generating: [CapturedTask].self,
      options: .init(samplingMode: .greedy)
    )

    // Map the response content into
    // an array of captured tasks
    let tasks = await response.content.asyncCompactMap { task -> TaskModel? in
      let trimmed = task.title.trimmingCharacters(in: .whitespacesAndNewlines)

      if trimmed.isEmpty == true {
        return nil
      }

      // Make sure the title starts with a capital
      // letter as the model doesn't always do this
      let title = trimmed.prefix(1).uppercased() + trimmed.dropFirst()

      // Only resolve a due date if the
      // model generated due date text
      if let dueDateText = task.dueDateText {
        let dueDate = await self._resolveDate(from: dueDateText)

        return TaskModel(
          title: title,
          dueDate: dueDate
        )
      }

      return TaskModel(title: title)
    }

    // Make sure at least one task
    // was captured from the text
    if (tasks.isEmpty == true) {
      throw TaskCaptureError.noTasks
    }

    return tasks
  }

  /// Used to resolve a `Date` relative to now from
  /// a given due date `text` such as "tomorrow"
  private func _resolveDate(from text: String) async -> Date? {
    var options = DataDetector.Options()
    options.documentDate = .now

    // Use the `DataDetector` to
    // detect any matches
    let matches = text.dataDetectorMatches(
      .calendarEvent,
      options: options
    )

    for await match in matches {

      // Use the start date of the first
      // calendar event that is detected
      if case .calendarEvent(let event) = match.details {
        return event.startDate
      }
    }

    return nil
  }
}
