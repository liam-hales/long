import FoundationModels

extension LanguageModelSession {

  /// Used to capture content of a given `type` from a `prompt`,
  /// converting any errors thrown by the model into a `TaskCaptureError`
  func capture<Content: Generable>(_ type: Content.Type, from prompt: String) async throws -> Content {
    do {

      // Use greedy sampling so the model always picks its
      // most likely output, making the capture consistent
      let response = try await self.respond(
        to: prompt,
        generating: type,
        options: .init(samplingMode: .greedy)
      )

      return response.content
    }
    catch {

      // Convert the model error into the matching capture
      // error, falling back to a generic failed error
      switch error {
        case LanguageModelError.guardrailViolation:
          throw TaskCaptureError.inputBlocked

        case LanguageModelError.refusal:
          throw TaskCaptureError.inputBlocked

        case LanguageModelError.contextSizeExceeded:
          throw TaskCaptureError.inputTooLong

        case LanguageModelError.unsupportedLanguageOrLocale:
          throw TaskCaptureError.unsupportedLanguage

        case LanguageModelError.rateLimited:
          throw TaskCaptureError.rateLimited

        case LanguageModelError.timeout:
          throw TaskCaptureError.timedOut

        default:
          throw TaskCaptureError.failed
      }
    }
  }
}
