import Foundation

extension Date {

  /// Formats the date into a human
  /// readable format relative to today
  func relativeText(includeTime: Bool = false) -> String {
    let calendar = Calendar.current

    // Extract the number of days it has been
    // from today since the date
    let days = calendar.dateComponents(
      [.day],
      from: calendar.startOfDay(for: .now),
      to: self
    ).day ?? 0

    let relativeStyle = Date.RelativeFormatStyle(
      allowedFields: [.day],
      presentation: .named,
      capitalizationContext: .middleOfSentence
    )

    // Dates more than a week either side of today are shown as
    // the full date, otherwise they're shown relative
    let dateText = (abs(days) > 7)
      ? self.formatted(
        date: .abbreviated,
        time: .omitted
      )
      : self.formatted(relativeStyle)

    // If the text should not include the time then
    // just return the date text as is
    if (includeTime == false) {
      return dateText
    }

    let timeText = self.formatted(
      date: .omitted,
      time: .shortened
    )

    return "\(dateText) at \(timeText)"
  }
}
