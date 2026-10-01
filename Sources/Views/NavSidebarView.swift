import LucideSwift
import SwiftData
import SwiftUI

/// Used to display the navigation
/// sidebar options for the app
struct NavSidebarView: View {
  private let _sizeClass: UserInterfaceSizeClass?

  @Environment(AppState.self)
  private var _appState: AppState

  @Environment(\.displayScale)
  private var _displayScale: CGFloat

  @Query
  private var _taskSheets: [TaskSheetModel]

  @Query
  private var _tasks: [TaskModel]

  private var _activeTasks: [TaskModel] {
    self._tasks.filter { task in task.isCompleted == false }
  }

  /// The subtitle summarising the number of task
  /// sheets and tasks yet to be completed
  private var _subtitle: String {
    let sheetText = "\(self._taskSheets.count) \((self._taskSheets.count == 1) ? "sheet" : "sheets")"
    let taskText = "\(self._activeTasks.count) \((self._activeTasks.count == 1) ? "task" : "tasks") to complete"

    return "\(sheetText) • \(taskText)"
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
      ForEach(self._sortedTaskSheets) { sheet in
        NavSidebarItemView(
          value: .taskSheet(sheet.id),
          sizeClass: self._sizeClass
        ) {
          Text(sheet.name)
            .padding(.top, 2)
        }
      }
      .listRowSeparator(.hidden)
    }
    .toolbar(removing: .sidebarToggle)
    .toolbarTitleDisplayMode(.large)
    .toolbar {
      ToolbarItem(placement: .largeTitle) {
        Text("Task Sheets")
          .font(.serif(28, .bold))
          .padding(.horizontal, 4)
          .padding(.top, 32)
          .padding(.bottom, -4)
          .frame(
            maxWidth: .infinity,
            alignment: .leading
          )
      }

      ToolbarItem(placement: .largeSubtitle) {
        Text(self._subtitle)
          .foregroundStyle(Color.contentSecondary)
          .font(.mono(14))
          .padding(.horizontal, 4)
          .frame(
            maxWidth: .infinity,
            alignment: .leading
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

      ToolbarItem(placement: .topBarTrailing) {
        Button(
          action: {
            self._appState.createTaskSheet(name: "Untitled")
          },
          label: {
            HStack(
              alignment: .center,
              spacing: 8
            ) {
              LucideIcon(.filePlusCorner, size: 22)

              Text("New Sheet")
                .font(.serif(14, .bold))
                .padding(.top, 2)
            }
            .padding(.horizontal, 6)
          }
        )
      }

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
      }
    }
    .safeAreaInset(
      edge: .trailing,
      spacing: 0
    ) {

      // Show the divider only if the
      // size class is set to `regular`
      if (self._sizeClass == .regular) {
        Rectangle()
          .fill(Color.outline)
          .frame(width: 2 / self._displayScale)
          .ignoresSafeArea(edges: .vertical)
          .allowsHitTesting(false)
      }
    }
    .listStyle(.plain)
    .navigationTitle("Task Sheets")
    .navigationSubtitle(self._subtitle)
    .listRowSpacing(10)
    .contentMargins(.top, 20, for: .scrollContent)
    .contentMargins(.bottom, 20, for: .scrollContent)
    .scrollContentBackground(.hidden)
    .background(Color.base)
  }
}
