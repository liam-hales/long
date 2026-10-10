import LucideSwift
import SwiftUI

/// Used to render a section of tasks
/// with a custom header
struct TaskSectionView: View {
  private let _title: String
  private let _icon: LucideIconName
  private let _headerColour: Color
  private let _headerInset: CGFloat
  private let _tasks: [TaskModel]
  private let _onTaskTap: ((TaskModel) -> Void)?

  /// Initialises the view with the `tasks` to render
  /// under a header with a given `title` and `icon`
  init(
    title: String,
    icon: LucideIconName,
    tasks: [TaskModel],
    headerColour: Color = .contentSecondary,
    headerInset: CGFloat = 8,
    onTaskTap: ((TaskModel) -> Void)? = nil
  ) {
    self._title = title
    self._icon = icon
    self._tasks = tasks
    self._headerColour = headerColour
    self._headerInset = headerInset
    self._onTaskTap = onTaskTap
  }

  /// Initialises the view with the `tasks`
  /// to render for a given `filter`
  init(
    filter: TaskFilter,
    tasks: [TaskModel]
  ) {

    // Get the header colour
    // for the given filter
    let headerColour: Color = switch filter {
      case .all: .contentSecondary
      case .overdue: .contentError
      case .today: .contentSecondary
      case .scheduled: .contentSecondary
      case .unscheduled: .contentSecondary
      case .completed: .contentSecondary
    }

    self.init(
      title: filter.title,
      icon: filter.icon,
      tasks: tasks,
      headerColour: headerColour,
    )
  }

  var body: some View {
    Section(
      content: {
        ForEach(self._tasks) { task in

          if (self._onTaskTap == nil) {
            TaskRowView(task: task)
          }

          if (self._onTaskTap != nil) {
            TaskRowView(task: task)
              .accessibilityAddTraits(.isButton)
              .onTapGesture {
                self._onTaskTap?(task)
              }
          }
        }
      },
      header: {
        HStack(
          alignment: .center,
          spacing: 6
        ) {
          LucideIcon(self._icon, size: 14)

          Text("\(self._title) • \(self._tasks.count)")
            .font(.mono(14))
        }
        .foregroundStyle(self._headerColour)
        .listRowInsets(.horizontal, self._headerInset)
      }
    )
    .listRowSeparator(.hidden)
  }
}
