import LucideSwift
import SwiftData
import SwiftUI

/// Used to display the navigation
/// sidebar for the app
struct NavSidebarView: View {
  private let _sizeClass: UserInterfaceSizeClass?

  @Environment(AppState.self)
  private var _appState: AppState

  @Environment(AppSettings.self)
  private var _appSettings: AppSettings

  @Environment(\.displayScale)
  private var _displayScale: CGFloat

  /// Used to force the view to rebuild when the
  /// app comes back from the background
  @Environment(\.scenePhase)
  private var _scenePhase: ScenePhase

  @Query
  private var _taskSheets: [TaskSheetModel]

  @Query(sort: \TaskModel.dueDate, order: .forward)
  private var _tasks: [TaskModel]

  /// The title greeting to the user which
  /// uses their preferred name if it's set
  private var _title: String {
    if (self._appSettings.preferredName.isEmpty == true) {
      return "Hello there."
    }

    return "Hello, \(self._appSettings.preferredName)."
  }

  /// The subtitle which will always be today's date written
  /// out in full e.g. "Wednesday, 21 October 2026"
  private var _subtitle: String {
    Date.now.formatted(date: .complete, time: .omitted)
  }

  /// The task sheets ordered by
  /// most recently active
  private var _sortedTaskSheets: [TaskSheetModel] {
    self._taskSheets.sorted { first, second in
      first.activityDate > second.activityDate
    }
  }

  /// Initialises the view with
  /// the app `sizeClass`
  init(sizeClass: UserInterfaceSizeClass?) {
    self._sizeClass = sizeClass
  }

  var body: some View {

    @Bindable
    var appState = _appState

    List(selection: $appState.navSelection) {

      if (self._appState.isSearching == true) {

        // Trim the search text from any
        // whitespace and new lines
        let query = self._appState
          .searchText
          .trimmingCharacters(in: .whitespacesAndNewlines)

        TaskSearchView(query: query)
      }

      if (self._appState.isSearching == false) {

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
              tasks: tasks
            ) { task in
              self._appState.revealTask(task)
            }
          }
        }

        Section(
          content: {
            ForEach(self._sortedTaskSheets) { sheet in
              let value: AppState.NavSelection = .taskSheet(sheet.id)

              TaskSheetRowView(
                sheet: sheet,
                isSelected: self._appState.navSelection == value
              )
              .tag(value)
            }
          },
          header: {
            HStack(
              alignment: .center,
              spacing: 6
            ) {
              LucideIcon(.fileText, size: 14)

              Text("Task Sheets • \(self._taskSheets.count)")
                .font(.mono(14))
            }
            .foregroundStyle(Color.contentSecondary)
            .padding(.horizontal, 8)
          }
        )
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
    .toolbar(removing: .sidebarToggle)
    .toolbarTitleDisplayMode(.large)
    .toolbar {
      ToolbarItem(placement: .largeTitle) {
        Text(self._title)
          .font(.serif(28, .semibold))
          .padding(.top, 32)
          .frame(
            maxWidth: .infinity,
            alignment: .center
          )
      }

      ToolbarItem(placement: .largeSubtitle) {
        Text(self._subtitle)
          .foregroundStyle(Color.contentSecondary)
          .font(.mono(14))
          .frame(
            maxWidth: .infinity,
            alignment: .center
          )
      }

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

      // Show the sidebar open button only
      // if the size class is set to `regular`
      if (self._sizeClass == .regular) {
        ToolbarSpacer(
          .fixed,
          placement: .topBarTrailing
        )

        ToolbarItem(placement: .topBarTrailing) {
          Button(
            action: {
              self._appState.navVisibility = .detailOnly
            },
            label: {
              LucideIcon(.panelRightOpen, size: 22)
            }
          )
        }
        .toolbarAxis(.vertical)
      }

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
    .navigationTitle(self._title)
    .navigationSubtitle(self._subtitle)
    .listRowSpacing(10)
    .listSectionSpacing(16)
    .contentMargins(.vertical, 8, for: .scrollContent)
    .scrollContentBackground(.hidden)
    .background {

      // The background fills the whole column including its safe area, so the
      // divider drawn on its trailing edge sits where the columns meet
      Color.base
        .overlay(alignment: .trailing) {

          // Show the divider only if the
          // size class is set to `regular`
          if (self._sizeClass == .regular) {
            Rectangle()
              .fill(Color.outline)
              .frame(width: 2 / self._displayScale)
          }
        }
        .ignoresSafeArea()
    }
  }
}
