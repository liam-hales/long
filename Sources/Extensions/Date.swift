import Foundation

extension Date {

  /// Formats the date into a human readable
  /// format based on the given date `format`
  func text(
    _ format: DateFormat,
    includeTime: Bool = false
  ) -> String {
    let calendar = Calendar.current
    let dateText: String

    // Extract the number of days it has been
    // from today since the date
    let days = calendar.dateComponents(
      [.day],
      from: calendar.startOfDay(for: .now),
      to: self
    ).day ?? 0

   switch format {
     case .relative:
       let relativeStyle = Self.RelativeFormatStyle(
         allowedFields: [.day],
         presentation: .named,
         capitalizationContext: .middleOfSentence
       )

       // Dates more than a week either side of today are shown
       // as the calendar date, otherwise they're shown relative
       dateText = (abs(days) > 7)
         ? self.formatted(date: .abbreviated, time: .omitted)
         : self.formatted(relativeStyle)

     case .calendar:
       dateText = self.formatted(date: .abbreviated, time: .omitted)

     case .numeric:
       let numericStyle = Self.FormatStyle()
         .day(.twoDigits)
         .month(.twoDigits)
         .year(.twoDigits)

       dateText = self.formatted(numericStyle)
    }

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
