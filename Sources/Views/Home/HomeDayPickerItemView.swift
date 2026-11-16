import SwiftUI

/// Used to render a single day in the home day picker,
/// with dots to represent tasks due on said day
struct HomeDayPickerItemView: View {
  private let _day: Date
  private let _count: Int
  private let _isSelected: Bool

  /// Determines whether the
  /// day is today or not
  private var _isToday: Bool {
    Calendar.current.isDateInToday(self._day)
  }

  /// The colour of the
  /// task count dots
  private var _dotColour: Color {
    (self._isSelected == true) ? .white : .accent
  }

  /// The colour of the dash shown
  /// when there are no tasks due
  private var _dashColour: Color {
    (self._isSelected == true) ? .white.opacity(0.6) : .disabled
  }

  /// The colour of the
  /// day background
  private var _surfaceColour: Color {
    (self._isSelected == true) ? .accent : .surfaceHigh
  }

  /// The colour of the
  /// day of the week letter
  private var _labelColour: Color {
    if (self._isSelected == true) {
      return .white
    }

    if (self._isToday == true) {
      return .accent
    }

    return .contentSecondary
  }

  /// The colour of the
  /// day of the month number
  private var _numberColour: Color {
    if (self._isSelected == true) {
      return .white
    }

    if (self._isToday == true) {
      return .accent
    }

    return .contentPrimary
  }

  /// The colour of the day outline, which marks
  /// today in the accent colour when not selected
  private var _outlineColour: Color {
    if (self._isSelected == true) {
      return .accent
    }

    if (self._isToday == true) {
      return .accent
    }

    return .outline
  }

  /// Initialises the view with the `day` to render, the
  /// `count` of tasks due and whether it `isSelected`
  init(
    day: Date,
    count: Int,
    isSelected: Bool
  ) {
    self._day = day
    self._count = count
    self._isSelected = isSelected
  }

  var body: some View {
    VStack(
      alignment: .center,
      spacing: 2
    ) {
      let dayText = self._day.formatted(.dateTime.weekday(.narrow))
      let dateText = self._day.formatted(.dateTime.day())

      Text(dayText)
        .foregroundStyle(self._labelColour)
        .font(.mono(11))

      Text(dateText)
        .foregroundStyle(self._numberColour)
        .font(.serif(19, .semibold))

      // Render a dot for each task due on the day capped at 4
      // so they always fit, or a dash when there are none due
      HStack(
        alignment: .center,
        spacing: 3
      ) {
        if (self._count == 0) {
          Capsule()
            .fill(self._dashColour)
            .frame(width: 10, height: 2)
        }

        if (self._count > 0) {
          ForEach(0 ..< min(self._count, 4), id: \.self) { _ in
            Circle()
              .fill(self._dotColour)
              .frame(width: 4, height: 4)
          }
        }
      }
      // Fix the height so the size of the parent
      // stays the same for days with no tasks due
      .frame(height: 4)
      .padding(.vertical, 3)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 8)
    .background(
      RoundedRectangle(cornerRadius: 14)
        .fill(self._surfaceColour)
        .strokeBorder(self._outlineColour, lineWidth: 1)
    )
    .contentShape(.rect(cornerRadius: 14))
  }
}
