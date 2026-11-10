import DataDetection
import Foundation
import FoundationModels

/// Used to capture tasks from a users
/// input text using the on-device model
final class TaskCaptureManager {

  /// Describes whether some text has anything
  /// in it the user needs or wants to do
  @Generable
  struct CaptureCheck {

    @Guide(description: "Whether the text contains anything the user needs or wants to do")
    let hasTask: Bool
  }

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
        The words from the text that say when the task is due, such as \
        "tomorrow", "by Friday" or "next week". Leave out if the text does \
        not say when the task is due.
        """
    )
    let dueDateText: String?
  }

  private var _checkSession: LanguageModelSession?
  private var _captureSession: LanguageModelSession?
  private let _checkInstructions: String
  private let _captureInstructions: String

  /// Initialises the `TaskCaptureManager` with
  /// the model instructions
  init() {
    self._checkInstructions =
    """
    You check text that the user typed into a to-do list app.

    Decide whether the text contains anything the user needs or wants to do, such as \
    an errand, a chore, a piece of work, an appointment or a problem to fix. A single \
    word naming an errand, place, person or item counts as something to do.

    Text that is only a greeting, a thank you, a question, small talk, a feeling, \
    something that already happened or random characters does not contain anything to do.
    """

    self._captureInstructions =
    """
    Your purpose is to extract tasks from text the user has written, \
    in the order they appear.

    Rules:
      - Split text that mentions several things to do into separate tasks.
      - Text that mentions one thing to do is one task.
      - Only include tasks that are in the text, never invent new ones.
      - Keep items that belong to one action in one task, such as several things to buy.
      - Dates always go in dueDateText and never in the title.

    Example:
      Text: "Water the garden on Saturday"
      Task: title "Water the garden", dueDateText "on Saturday"
    """
  }

  /// Used to initialise and prewarm
  /// the model sessions before use
  func startSession() {
    let model = SystemLanguageModel(useCase: .contentTagging)

    // Only start the model sessions if
    // they do not already exist
    if (self._captureSession != nil) {
      return
    }

    self._checkSession = .init(model: model, instructions: self._checkInstructions)
    self._captureSession = .init(model: model, instructions: self._captureInstructions)

    // Prewarm both models so they are
    // ready to use when needed
    self._checkSession?.prewarm()
    self._captureSession?.prewarm()
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

    // Make sure the model sessions have
    // been started and prewarmed
    guard
      let checkSession = self._checkSession,
      let captureSession = self._captureSession
    else {
      throw TaskCaptureError.sessionNotStarted
    }

    // Clear the sessions so they can
    // only be used for one capture
    self._checkSession = nil
    self._captureSession = nil

    let check = try await checkSession.capture(
      CaptureCheck.self,
      from: "Text:\n\(text)"
    )

    // Check if any tasks have been
    // found in the input text
    if (check.hasTask == false) {
      throw TaskCaptureError.noTasks
    }

    let capturedTasks = try await captureSession.capture(
      [CapturedTask].self,
      from: "Extract the tasks from this text:\n\n\(text)"
    )

    // Map the captured tasks into an array of
    // tasks with their due dates resolved
    let tasks = await capturedTasks.asyncCompactMap { task -> TaskModel? in
      let trimmedTitle = task.title.trimmingCharacters(in: .whitespacesAndNewlines)

      // Make sure the task title set
      // by the model is not empty
      if (trimmedTitle.isEmpty == true) {
        return nil
      }

      // Make sure the title is grounded in the input text, if
      // not it's most likely a task that the model has made up
      if (self._isGrounded(trimmedTitle, in: text) == false) {
        return nil
      }

      // Make sure the title starts with a capital
      // letter as the model doesn't always do this
      let cap = trimmedTitle.prefix(1).uppercased()
      let title = "\(cap)\(trimmedTitle.dropFirst())"

      if let dueDateText = task.dueDateText {

        // Only resolve a due date if the
        // model generated due date text
        let trimmedDate = dueDateText.trimmingCharacters(in: .whitespacesAndNewlines)
        let dueDate = await self._resolveDate(from: trimmedDate)

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

  /// Used to check that a `title` shares at least one word with the
  /// input `text`, which is used to catch tasks the model made up
  private func _isGrounded(_ title: String, in text: String) -> Bool {

    // Split into words of at least 4 letters, only using the first
    // 4 letters so "groceries" in the text matches "grocery"
    let words = { (string: String) in
      string
        .lowercased()
        .split { $0.isLetter == false }
        .filter { $0.count >= 4 }
        .map { $0.prefix(4) }
    }

    let titleWords = words(title)
    let textWords = words(text)

    // Keep short titles as they have
    // no long words to compare
    if (titleWords.isEmpty == true) {
      return true
    }

    return titleWords.contains { textWords.contains($0) }
  }

  /// Used to resolve a `Date` relative to now from
  /// a given due date `text` such as "tomorrow"
  private func _resolveDate(from text: String) async -> Date? {
    let calendar = Calendar.current

    if (text.isEmpty == true) {
      return nil
    }

    var options = DataDetector.Options()
    options.documentDate = .now

    // Use the `DataDetector` to detect any matches
    // from the normalised version of the text
    let matches = self._normaliseDate(text).dataDetectorMatches(
      .calendarEvent,
      options: options
    )

    for await match in matches {

      // Extract the start date
      // from the match event
      guard
        case .calendarEvent(let event) = match.details,
        let startDate = event.startDate
      else {
        continue
      }

      let today = calendar.startOfDay(for: .now)
      let date = calendar.startOfDay(for: startDate)

      // Keep dates the user explicitly said are in the past, such
      // as "yesterday" or "last Friday", so they are added as overdue
      if (text.contains(#/\b(yesterday|last)\b/#.ignoresCase()) == true) {
        return date
      }

      // Move other dates that are in
      // the past to next year
      if (date < today) {
        return calendar.date(
          byAdding: .year,
          value: 1,
          to: date
        )
      }

      return date
    }

    return nil
  }

  /// Used to rewrite a due date `text` into a
  /// phrase the `DataDetector` understands
  private func _normaliseDate(_ text: String) -> String {
    let calendar = Calendar.current

    // Remove words in front of the date, some of which make
    // the `DataDetector` return today, such as "before Friday"
    let cleanedText = text
      .lowercased()
      .replacing(#/^(by|before|until|due|on|for) /#, with: "")

    // Replace phrases that don't name a day
    // with the day that is most likely meant
    let phrases = [
      "this week": "Friday",
      "end of the week": "Friday",
      "the end of the week": "Friday",
      "weekend": "Saturday",
      "the weekend": "Saturday",
      "this weekend": "Saturday",
      "next week": "Monday next week",
    ]

    // If the text matches one of
    // these phrases then return it
    if let phrase = phrases[cleanedText] {
      return phrase
    }

    // If the text is formatted as something such as "the 10th"
    // then work out how many days away that day is
    if let match = cleanedText.wholeMatch(of: #/(?:the )?(\d{1,2})(?:st|nd|rd|th)/#) {

      let day = Int(match.1) ?? 1
      let today = calendar.component(.day, from: .now)
      let daysInMonth = calendar.range(of: .day, in: .month, for: .now)?.count ?? 30

      // Use the day next month if
      // it has already passed
      let days = (day < today)
        ? daysInMonth - today + day
        : day - today

      return "in \(days) days"
    }

    // Rewrite an amount such as "two weeks" in days as the `DataDetector`
    // requires digits and only understands up to 3 weeks
    let amountRegex = #/(?:in )?(\d{1,3}|a|one|two|three|four|five|six|seven|eight|nine|ten) (day|week)s?(?: from now)?/#
    let numbers = [
      "a": 1,
      "one": 1,
      "two": 2,
      "three": 3,
      "four": 4,
      "five": 5,
      "six": 6,
      "seven": 7,
      "eight": 8,
      "nine": 9,
      "ten": 10,
    ]

    if let match = cleanedText.wholeMatch(of: amountRegex) {

      // If there is a match then extract the
      // number of days to build the phrase
      let amount = Int(match.1) ?? numbers[String(match.1)] ?? 1
      let days = (match.2 == "week")
        ? amount * 7
        : amount

      return "in \(days) days"
    }

    return cleanedText
  }
}
