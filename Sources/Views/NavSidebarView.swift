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
      Section(
        content: {
          VStack(
            alignment: .leading,
            spacing: 14
          ) {
            HStack(
              alignment: .center,
              spacing: 12
            ) {
              let count = self._tasks
                .filter { $0.schedule == .today }
                .count

              LucideIcon(.sun, size: 20)
                .foregroundStyle(Color.contentSecondary)

              Text("\(count) \((count == 1) ? "task" : "tasks") today")
                .foregroundStyle(Color.contentSecondary)
                .font(.mono(14))
                .padding(.top, 0.5)
            }

            HStack(
              alignment: .center,
              spacing: 12
            ) {
              let count = self._tasks
                .filter { $0.schedule == .scheduled }
                .count

              LucideIcon(.calendarCheck2, size: 20)
                .foregroundStyle(Color.contentSecondary)

              Text("\(count) \((count == 1) ? "task" : "tasks") scheduled")
                .foregroundStyle(Color.contentSecondary)
                .font(.mono(14))
                .padding(.top, 0.5)
            }

            HStack(
              alignment: .center,
              spacing: 12
            ) {
              let count = self._tasks
                .filter { $0.isCompleted == true }
                .count

              LucideIcon(.check, size: 20)
                .foregroundStyle(Color.contentSecondary)

              Text("\(count) \((count == 1) ? "task" : "tasks") completed")
                .foregroundStyle(Color.contentSecondary)
                .font(.mono(14))
                .padding(.top, 0.5)
            }
          }
        },
        header: {
          Text("Summary")
            .font(.serif(22, .bold))
            .listRowInsets(.horizontal, 20)
        }
      )
      .listRowBackground(Color.clear)
      .listRowSeparator(.hidden)
      .listRowInsets(.horizontal, 8)

      Section(
        content: {
          ForEach(self._sortedTaskSheets) { sheet in
            NavSidebarItemView(
              value: .taskSheet(sheet.id),
              sizeClass: self._sizeClass
            ) {
              Text(sheet.name)
                .padding(.top, 2)
            }
          }
        },
        header: {
          HStack(
            alignment: .center,
            spacing: 10
          ) {
            Text("Task Sheets")
              .font(.serif(22, .bold))

            Text("• \(self._taskSheets.count)")
              .foregroundStyle(Color.contentSecondary)
              .font(.mono(16))
              .padding(.bottom, 2)
          }
          .listRowInsets(.horizontal, 20)
        }
      )
      .listRowSeparator(.hidden)
    }
    .toolbar(removing: .sidebarToggle)
    .toolbarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button(
          action: {
            self._appState.sheetSelection = .settings
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
            .padding(.horizontal, 8)
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
    .listRowSpacing(10)
    .contentMargins(.top, 0, for: .scrollContent)
    .scrollContentBackground(.hidden)
    .background(Color.base)
  }
}
