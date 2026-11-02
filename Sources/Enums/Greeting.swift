import Foundation

/// Describes the greeting shown to the user
/// for the different times of the day
enum Greeting {
  case morning
  case afternoon
  case evening
  case lateNight

  /// Initialises the greeting from
  /// the hour of the given `date`
  init(date: Date) {

    // Get the current hour to determine
    // the correct time of day
    let hour = Calendar
      .current
      .component(.hour, from: date)

    switch hour {
      case 5 ..< 12: self = .morning
      case 12 ..< 17: self = .afternoon
      case 17 ..< 22: self = .evening
      default: self = .lateNight
    }
  }

  /// Describes the greeting texts
  /// for the time of day
  private var _texts: [String] {
    switch self {
      case .morning: [
        "Good morning.",
        "Sleep well?",
        "Rise and shine.",
        "Bright and early.",
        "Let's get going.",
        "Ready for today?",
      ]

      case .afternoon: [
        "Good afternoon.",
        "Good to see you.",
        "Making progress?",
        "Busy day?",
        "Afternoon already?",
        "What's next?",
      ]

      case .evening: [
        "Good evening.",
        "Welcome back.",
        "Winding down?",
        "Long day?",
        "Evening plans?",
        "Almost done?",
      ]

      case .lateNight: [
        "Still up?",
        "Late one?",
        "Can't sleep?",
        "Working late?",
        "Past your bedtime?",
        "One more thing?",
      ]
    }
  }

  /// Picks the greeting text using the given
  /// `seed` and inserts an optional `name`
  func text(
    seed: Int,
    name: String?
  ) -> String {
    let text = self._texts[seed % self._texts.count]

    // If the name has not been set or is empty
    // then just return the greeting as is
    guard let name, name.isEmpty == false else {
      return text
    }

    // Insert the name before the greetings
    // final punctuation e.g. "Still up, Liam?"
    return "\(text.dropLast()), \(name)\(text.suffix(1))"
  }
}
