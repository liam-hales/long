import LucideSwift
import SwiftData
import SwiftUI

/// Used to display the home view which shows
/// tasks that need attention and the task sheets
struct HomeView: View {

  @Environment(AppState.self)
  private var _appState: AppState

  @Environment(AppSettings.self)
  private var _appSettings: AppSettings

  /// Used to force the view to rebuild when the
  /// app comes back from the background
  @Environment(\.scenePhase)
  private var _scenePhase: ScenePhase

  @Query
  private var _taskSheets: [TaskSheetModel]

  @Query(
    filter: #Predicate<TaskModel> { $0.sheet != nil },
    sort: \TaskModel.dueDate,
    order: .forward
  )
  private var _tasks: [TaskModel]

  /// The task sheets ordered by
  /// the users preferred sort
  private var _sortedTaskSheets: [TaskSheetModel] {
    self._taskSheets.sorted(by: self._appSettings.taskSheetSort)
  }

  var body: some View {

    @Bindable
    var appState = _appState

    @Bindable
    var appSettings = _appSettings

    // Swap between the search and home lists in a `ZStack` so the
    // search and toolbar modifiers stay attached to a single view
    ZStack {
      if (self._appState.isSearching == true) {

        // Trim the search text from any
        // whitespace and new lines
        let query = self._appState
          .searchText
          .trimmingCharacters(in: .whitespacesAndNewlines)

        TaskSearchView(query: query)
      }

      if (self._appState.isSearching == false) {
        List(selection: $appState.navSelection) {
          HomeHeaderView()

          let filters = [
            TaskFilter.overdue,
            TaskFilter.today,
          ]

          // Section and render the tasks by
          // the overdue and today filters
          ForEach(filters) { filter in
            let tasks = self._tasks.filtered(by: filter)

            if (tasks.isEmpty == false) {
              TaskSectionView(
                filter: filter,
                tasks: tasks,
                isCompact: true
              ) { task in
                self._appState.revealTask(task)
              }
            }
          }

          SectionView(
            title: "Task Sheets",
            icon: .fileText,
            count: self._taskSheets.count
          ) {
            ForEach(self._sortedTaskSheets) { sheet in
              let value: AppState.NavSelection = .taskSheet(sheet.id)

              TaskSheetRowView(
                sheet: sheet,
                isSelected: self._appState.navSelection == value
              )
              .tag(value)
            }
          }
        }
      }
    }
    .searchable(
      text: $appState.searchText,
      isPresented: $appState.isSearching,
      prompt: Text("Search tasks"),
    )
    .searchScopes($appState.searchScope) {
      ForEach(TaskSearchScope.allCases) { scope in
        Text(scope.title).tag(scope)
      }
    }
    .searchToolbarBehavior(.minimize)
    .toolbarMinimizationBehavior(.onScrollDown, for: .navigationBar)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(
          action: {
            self._appState.createTaskSheet(name: "Untitled")
          },
          label: {
            LucideIcon(.filePlusCorner, size: 22)
          }
        )
      }
      .toolbarAxis(.vertical)

      ToolbarItem(placement: .topBarTrailing) {
        Menu(
          content: {
            Picker("Sort By", selection: $appSettings.taskSheetSort) {
              ForEach(TaskSheetSort.allCases) { sort in
                Label(
                  title: {
                    Text(sort.title)
                  },
                  icon: {
                    Image(
                      lucide: sort.icon,
                      size: .init(width: 22, height: 22)
                    )
                  }
                )
              }
            }
            .tint(.contentPrimary)
            .pickerStyle(.inline)
          },
          label: {
            LucideIcon(.arrowUpDown, size: 22)
          }
        )
      }
      .toolbarAxis(.vertical)

      ToolbarItem(placement: .topBarLeading) {
        Button(
          action: {
            self._appState.modalSelection = .settings
          },
          label: {
            LucideIcon(.settings, size: 22)
          }
        )
      }
      .toolbarAxis(.vertical)

      ToolbarSpacer(
        .flexible,
        placement: .bottomBar
      )

      DefaultToolbarItem(
        kind: .search,
        placement: .bottomBar
      )
    }
    .listStyle(.plain)
    .listRowSpacing(10)
    .listSectionSpacing(16)
    .contentMargins(.vertical, 16, for: .scrollContent)
    .scrollContentBackground(.hidden)
  }
}
