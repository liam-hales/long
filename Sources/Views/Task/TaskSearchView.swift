import LucideSwift
import SwiftData
import SwiftUI

/// Used to display all tasks across all task
/// sheets that match a given search `query`
struct TaskSearchView: View {

  /// Describes the result group which holds a task
  /// sheet and its tasks that match the search query
  struct ResultGroup: Identifiable {
    let sheet: TaskSheetModel
    let tasks: [TaskModel]

    var id: TaskSheetModel.ID {
      self.sheet.id
    }
  }

  private let _query: String

  @Environment(AppState.self)
  private var _appState: AppState

  @Query
  private var _tasks: [TaskModel]

  /// Initialises the view with
  /// the task search `query`
  init(query: String) {
    self._query = query

    // Query for all tasks across all task sheets filtered by
    // the given `query` ordered by ones that are due first
    self.__tasks = Query(
      filter: #Predicate<TaskModel> { task in
        task.title.localizedStandardContains(query)
      },
      sort: \TaskModel.dueDate,
      order: .forward
    )
  }

  /// The tasks filtered by the
  /// current search scope
  private var _scopedTasks: [TaskModel] {

    // Filter the tasks by ones
    // that are currently active
    let active = self._tasks.filter { task in task.isSettled == false }

    // Sort the tasks by ones
    // that have been completed
    let sort = SortDescriptor(\TaskModel.completedDate, order: .reverse)
    let completed = self._tasks
      .filter { task in task.isSettled == true }
      .sorted(using: sort)

    // Return the tasks for
    // each search scope
    switch self._appState.searchScope {
      case .all:
        return active + completed

      case .active:
        return active

      case .completed:
        return completed
    }
  }

  /// The matching result groups ordered
  /// by task sheet most recently active
  private var _resultGroups: [ResultGroup] {

    // Group the tasks by the
    // task sheet they belong to
    let tasksBySheet = Dictionary(grouping: self._scopedTasks) { task in task.sheet }

    // Map the tasks grouped by sheet into a result group
    // and sort them by task sheet activity date
    return tasksBySheet
      .compactMap { sheet, tasks in
        guard let sheet else {
          return nil
        }

        return ResultGroup(
          sheet: sheet,
          tasks: tasks
        )
      }
      .sorted { first, second in
        first.sheet.activityDate > second.sheet.activityDate
      }
  }

  var body: some View {

    if (self._query.isEmpty == true) {
      NoContentView(
        title: "Search tasks.",
        message: "Search for tasks by title across all of your task sheets."
      )
    }

    if (self._query.isEmpty == false) {
      if (self._resultGroups.isEmpty == true) {
        let tasks = self._appState.searchScope.tasksDescription

        NoContentView(
          title: "No results.",
          message: "There were no \(tasks) found matching your search \"\(self._query)\"."
        )
      }

      if (self._resultGroups.isEmpty == false) {
        ForEach(self._resultGroups) { group in

          // Extract the title and tasks
          // from the result group
          let title = group.sheet.name
          let tasks = group.tasks

          TaskSectionView(
            title: title,
            icon: .fileText,
            tasks: tasks,
            headerInset: 24,
          ) { task in
            self._appState.revealTask(task)
          }
        }
      }
    }
  }
}
