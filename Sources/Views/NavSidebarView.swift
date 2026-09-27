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

  /// Query for the task sheets ordered
  /// by updated most recent
  @Query(
    sort: \TaskSheetModel.createDate,
    order: .reverse
  )
  private var _taskSheets: [TaskSheetModel]

  /// Query for all the tasks that
  /// have not been archived
  @Query(
    filter: #Predicate<TaskModel> { task in
      task.isArchived == false
    }
  )
  private var _tasks: [TaskModel]

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
                .filter { $0.status == .today }
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
                .filter { $0.status == .scheduled }
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
                .filter { $0.status == .completed }
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
          ForEach(self._taskSheets) { sheet in
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
          Text("Task Sheets")
            .font(.serif(22, .bold))
            .listRowInsets(.horizontal, 20)
        }
      )
      .listRowSeparator(.hidden)

      Section {
        NavSidebarItemView(
          value: .archived,
          sizeClass: self._sizeClass
        ) {
          LucideIcon(.archive, size: 22)

          Text("Archived")
            .padding(.top, 2)
        }
      }
      .listRowSeparator(.hidden)
      .listSectionSpacing(40)
    }
    .toolbar(removing: .sidebarToggle)
    .toolbarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button(
          action: {
            self._appState.isSettingsPresented = true
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
