import DataDetection
import Foundation
import FoundationModels

/// Used to capture tasks from a users
/// input text using the on-device model
@MainActor
final class TaskCaptureService {

  /// Describes the errors that can
  /// happen when capturing tasks
  enum CaptureError: Error {
    case modelUnavailable
  }

  /// Describes a single task the on
  /// device model should generate
  @Generable
  struct CapturedTask {
    @Guide(
      description:
        """
        A short, actionable title for the task written in sentence case \
        that starts with a verb, without any due date words
        """
    )
    let title: String

    @Guide(
      description:
        """
        When the task is due, rewritten as a simple date phrase such as "tomorrow", \
        "Friday", "next Monday at 9am", "in 3 days" or "October 12 at 5pm".

        Never work out the actual date yourself.
        Leave out if no due date is mentioned.
        """
    )
    let dueDateText: String?
  }

  private static let _instructions =
    """
    Your purpose is to extract tasks from text the user has written, \
    in the order they appear.

    Rules:
      - Split text that mentions several things into separate tasks.
      - Only include tasks that are in the text, never invent new ones.
    """

  /// Used to capture tasks from a given `text` as
  /// unsaved pending tasks for the user to review
  func capture(from text: String) async throws -> [TaskModel] {

    // Make sure the on device model can be used, it
    // may be unsupported, turned off or still downloading
    guard SystemLanguageModel.default.isAvailable else {
      throw CaptureError.modelUnavailable
    }

    // Use a new session for each capture so previous
    // inputs are not included in the transcript
    let session = LanguageModelSession(instructions: Self._instructions)
    let response = try await session.respond(
      to: text,
      generating: [CapturedTask].self
    )

    // Map the resposne content into
    // an array of captured tasks
    return await response.content.asyncCompactMap { task -> TaskModel? in
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
