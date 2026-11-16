import LucideSwift
import SwiftUI

/// Used to render the section of tasks due on
/// the day selected in the home day picker
struct HomeDueSectionView: View {
  private let _day: Date
  private let _tasks: [TaskModel]

  @Environment(AppState.self)
  private var _appState: AppState

  private var _isToday: Bool {
    Calendar.current.isDateInToday(self._day)
  }

  /// The section title which is "Today" for today, otherwise
  /// the full day of the week name e.g. "Tuesday"
  private var _title: String {
    (self._isToday == true)
      ? TaskFilter.today.title
      : self._day.formatted(.dateTime.weekday(.wide))
  }

  /// The icon to use for
  /// the task section
  private var _icon: LucideIconName {
    (self._isToday == true)
      ? TaskFilter.today.icon
      : .calendarDays
  }

  /// The header colour to use
  /// for the task section
  private var _headerColour: Color {
    (self._isToday == true)
      ? .contentWarning
      : .contentSecondary
  }

  /// The text to display when no
  /// tasks are due on the day
  private var _nothingDueText: String {
    (self._isToday == true)
      ? "Nothing due today"
      : "Nothing due on \(self._title)"
  }

  /// Initialises the view with the `day` to
  /// render and the `tasks` due on it
  init(day: Date, tasks: [TaskModel]) {
    self._day = day
    self._tasks = tasks
  }

  var body: some View {
    if (self._tasks.isEmpty == false) {
      TaskSectionView(
        title: self._title,
        icon: self._icon,
        tasks: self._tasks,
        headerColour: self._headerColour,
        isCompact: true
      ) { task in
        self._appState.revealTask(task)
      }
    }

    // Keep the section in place when there's nothing due so
    // the list doesn't jump around as the user picks days
    if (self._tasks.isEmpty == true) {
      SectionView(
        title: self._title,
        icon: self._icon,
        count: 0,
        headerColour: self._headerColour
      ) {
        Text(self._nothingDueText)
          .foregroundStyle(Color.contentSecondary)
          .font(.mono(12))
          .frame(maxWidth: .infinity)
          .padding(.vertical, 14)
          .background(
            RoundedRectangle(cornerRadius: 14)
              .strokeBorder(
                Color.outline,
                style: StrokeStyle(lineWidth: 1, dash: [4, 4])
              )
          )
          .listRowSeparator(.hidden)
          .listRowInsets(.vertical, 0)
          .listRowBackground(Color.clear)
      }
    }
  }
}
