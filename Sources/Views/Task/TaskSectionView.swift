import LucideSwift
import SwiftUI

/// Used to render a section of tasks
/// with a custom header
struct TaskSectionView: View {
  private let _filter: TaskFilter
  private let _tasks: [TaskModel]

  private var _headerColour: Color {

    // Return the header colour
    // for the set filter
    switch self._filter {
      case .all: Color.contentSecondary
      case .overdue: Color.contentError
      case .today: Color.contentSecondary
      case .scheduled: Color.contentSecondary
      case .unscheduled: Color.contentSecondary
      case .completed: Color.contentSecondary
    }
  }

  /// Initialises the view with the `tasks`
  /// to render for a given `filter`
  init(
    filter: TaskFilter,
    tasks: [TaskModel]
  ) {
    self._filter = filter
    self._tasks = tasks
  }

  var body: some View {
    Section(
      content: {
        ForEach(self._tasks) { task in
          TaskRowView(task: task)
        }
      },
      header: {
        HStack(
          alignment: .center,
          spacing: 6
        ) {
          LucideIcon(self._filter.icon, size: 14)

          Text("\(self._filter.title) • \(self._tasks.count)")
            .font(.mono(14))
        }
        .foregroundStyle(self._headerColour)
        .listRowInsets(.horizontal, 8)
      }
    )
    .listRowSeparator(.hidden)
  }
}
