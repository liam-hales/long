/// Describes the errors that can
/// happen when capturing tasks
enum TaskCaptureError: Error, CustomStringConvertible {
  case deviceNotSupported
  case appleIntelligenceDisabled
  case modelNotReady
  case modelUnavailable
  case sessionNotStarted
  case noTasks
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
        "Could not find any tasks. Rephrase what you need to get done and try again."

      case .sessionNotStarted, .failed:
        "Failed to capture tasks, please try again."
    }
  }
}
