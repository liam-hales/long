import Foundation
import LucideSwift

/// Describes the different formats the
/// user can choose to display dates in
enum DateFormat: String, CaseIterable, Identifiable {
  case relative = "relative"
  case calendar = "calendar"
  case numeric = "numeric"

  var id: Self {
    self
  }

  /// Describes the date
  /// format title
  var title: String {
    switch self {
      case .relative: "Relative"
      case .calendar: "Calendar"
      case .numeric: "Numeric"
    }
  }

  /// Describes the date
  /// format icon
  var icon: LucideIconName {
    switch self {
      case .relative: .clock
      case .calendar: .calendar
      case .numeric: .hash
    }
  }

  /// Describes an example of tomorrow's date formatted
  /// with the date format, shown in the settings row
  var example: String {
    let date = Calendar.current.date(
      byAdding: .day,
      value: 1,
      to: .now
    ) ?? .now

    return "Due \(date.text(self))"
  }
}
