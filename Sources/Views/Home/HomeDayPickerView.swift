import SwiftUI

/// Used to display the next seven days on the home view,
/// letting the user pick which day to see tasks for
struct HomeDayPickerView: View {
  private let _tasks: [TaskModel]
  private let _selectedDay: Date
  private let _onDayTap: (Date) -> Void

  /// The next seven days
  /// starting from today
  private var _days: [Date] {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: .now)

    return (0 ..< 7).compactMap { offset in
      calendar.date(
        byAdding: .day,
        value: offset,
        to: today
      )
    }
  }

  /// Initialises the view with the `tasks` to count for each day,
  /// the `selectedDay` and the action to run when a day is tapped
  init(
    tasks: [TaskModel],
    selectedDay: Date,
    onDayTap: @escaping (Date) -> Void
  ) {
    self._tasks = tasks
    self._selectedDay = selectedDay
    self._onDayTap = onDayTap
  }

  var body: some View {
    HStack(
      alignment: .center,
      spacing: 6
    ) {
      ForEach(self._days, id: \.self) { day in
        let count = self._tasks.filtered(by: day).count
        let isSelected = Calendar
          .current
          .isDate(day, inSameDayAs: self._selectedDay)

        Button(
          action: {
            self._onDayTap(day)
          },
          label: {
            HomeDayPickerItemView(
              day: day,
              count: count,
              isSelected: isSelected
            )
          }
        )
        .buttonStyle(.plain)
        .accessibilityAddTraits(
          (isSelected == true)
            ? .isSelected
            : []
        )
      }
    }
    .listRowSeparator(.hidden)
    .listRowInsets(.vertical, 0)
    .listRowBackground(Color.clear)
  }
}
