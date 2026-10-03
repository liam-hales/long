/// Describes the errors that can
/// happen when capturing tasks
enum TaskCaptureError: Error, CustomStringConvertible {
  case modelUnavailable
  case sessionNotStarted

  /// Describes the error
  /// description message
  var description: String {
    switch self {
      case .modelUnavailable: "The on-device model is unavailable"
      case .sessionNotStarted: "The model session has not been started, \".startSession()\" must be called first"
    }
  }
}
