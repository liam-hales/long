/// Describes the errors that can
/// happen when capturing tasks
enum TaskCaptureError: Error, CustomStringConvertible {
  case deviceNotSupported
  case appleIntelligenceDisabled
  case modelNotReady
  case modelUnavailable
  case sessionNotStarted
  case noTasks
  case inputBlocked
  case inputTooLong
  case unsupportedLanguage
  case rateLimited
  case timedOut
  case failed

  /// Describes the error description message
  /// used for debugging purposes
  var description: String {
    switch self {
      case .deviceNotSupported:
        "The device does not support Apple Intelligence"

      case .appleIntelligenceDisabled:
        "Apple Intelligence is disabled"

      case .modelNotReady:
        "The on-device model is not yet ready"

      case .modelUnavailable:
        "The on-device model is unavailable"

      case .sessionNotStarted:
        "The model session has not been started, \".startSession()\" must be called first"

      case .noTasks:
        "No tasks were captured from the given text"

      case .inputBlocked:
        "The input was blocked by the model guardrails or the model refused to respond"

      case .inputTooLong:
        "The input is larger than the model context size"

      case .unsupportedLanguage:
        "The text is in a language or locale the model does not support"

      case .rateLimited:
        "The model rate limited the request"

      case .timedOut:
        "The model took too long to respond"

      case .failed:
        "An error occurred while capturing tasks"
    }
  }

  /// Describes the error title
  /// displayed to the user
  var title: String {
    switch self {
      case .deviceNotSupported:
        "Device not supported"

      case .appleIntelligenceDisabled:
        "Apple Intelligence is off"

      case .modelNotReady:
        "Apple Intelligence not ready"

      case .modelUnavailable:
        "Apple Intelligence unavailable"

      case .noTasks:
        "No tasks found"

      case .inputBlocked:
        "Unable to capture tasks"

      case .inputTooLong:
        "Too much text"

      case .unsupportedLanguage:
        "Language not supported"

      case .rateLimited:
        "Apple Intelligence is busy"

      case .timedOut:
        "Capture timed out"

      case .sessionNotStarted, .failed:
        "Failed to capture tasks"
    }
  }

  /// Describes the error message
  /// displayed to the user
  var message: String {
    switch self {
      case .deviceNotSupported:
        "In order to capture tasks, your device needs to support Apple Intelligence."

      case .appleIntelligenceDisabled:
        "Apple Intelligence is disabled, please enable it in your device settings and try again."

      case .modelNotReady:
        "Apple Intelligence is not yet ready, please try again later."

      case .modelUnavailable:
        "Apple Intelligence is currently unavailable, please try again later."

      case .noTasks:
        "Could not find any tasks. Try rephrasing what you need to get done and try again."

      case .inputBlocked:
        "Apple Intelligence has blocked this text from being captured. Try rephrasing it and try again."

      case .inputTooLong:
        "There is too much text to capture tasks from. Try capturing fewer tasks at a time."

      case .unsupportedLanguage:
        "Apple Intelligence doesn't support this language yet. Try writing your tasks in another language."

      case .rateLimited:
        "Too many tasks have been captured in a short time, please wait a moment and try again."

      case .timedOut:
        "Capturing tasks took too long, please try again."

      case .sessionNotStarted, .failed:
        "Failed to capture tasks, please try again."
    }
  }
}
