import LucideSwift
import SwiftData
import SwiftUI

/// Used to render a section of tasks
/// with a custom header
struct TaskSectionView: View {
  private let _title: String
  private let _icon: LucideIconName
  private let _headerColour: Color
  private let _tasks: [TaskModel]
  private let _isCompact: Bool
  private let _onTaskTap: ((TaskModel) -> Void)?

  @Environment(AppState.self)
  private var _appState: AppState

  @Environment(AppSettings.self)
  private var _appSettings: AppSettings

  /// Initialises the view with the `tasks` to render
  /// under a header with a given `title` and `icon`
  init(
    title: String,
    icon: LucideIconName,
    tasks: [TaskModel],
    headerColour: Color = .contentSecondary,
    isCompact: Bool = false,
    onTaskTap: ((TaskModel) -> Void)? = nil
  ) {
    self._title = title
    self._icon = icon
    self._tasks = tasks
    self._headerColour = headerColour
    self._isCompact = isCompact
    self._onTaskTap = onTaskTap
  }

  /// Initialises the view with the `tasks`
  /// to render for a given `filter`
  init(
    filter: TaskFilter,
    tasks: [TaskModel],
    isCompact: Bool = false,
    onTaskTap: ((TaskModel) -> Void)? = nil
  ) {

    // Get the header colour
    // for the given filter
    let headerColour: Color = switch filter {
      case .all: .contentSecondary
      case .overdue: .contentError
      case .today: .contentWarning
      case .scheduled: .contentSecondary
      case .unscheduled: .contentSecondary
      case .completed: .contentSecondary
    }

    self.init(
      title: filter.title,
      icon: filter.icon,
      tasks: tasks,
      headerColour: headerColour,
      isCompact: isCompact,
      onTaskTap: onTaskTap
    )
  }

  var body: some View {
    SectionView(
      title: self._title,
      icon: self._icon,
      count: self._tasks.count,
      headerColour: self._headerColour
    ) {
      ForEach(self._tasks) { task in
        let isSelected = self._appState.revealedTaskId == task.id

        if (self._onTaskTap == nil) {
          TaskRowView(
            task: task,
            dateFormat: self._appSettings.dateFormat,
            isSelected: isSelected,
            isCompact: self._isCompact
          )
        }

        if (self._onTaskTap != nil) {
          TaskRowView(
            task: task,
            dateFormat: self._appSettings.dateFormat,
            isSelected: isSelected,
            isCompact: self._isCompact
          )
          .accessibilityAddTraits(.isButton)
          .onTapGesture {
            self._onTaskTap?(task)
          }
        }
      }
    }
  }
}
