import SwiftData
import SwiftUI

/// The main entry point view
/// rendered by the `App`
struct AppView: View {

  @Environment(AppState.self)
  private var _appState: AppState

  @Environment(AppSettings.self)
  private var _appSettings: AppSettings

  @Environment(\.horizontalSizeClass)
  private var _sizeClass: UserInterfaceSizeClass?

  @Query
  private var _taskSheets: [TaskSheetModel]

  /// The column shown when the split view is collapsed, calculated
  /// from the nav selection so it doesn't rely on the sidebar list
  private var _navColumn: Binding<NavigationSplitViewColumn> {
    Binding(
      get: {

        // Show the sidebar if there is
        // nothing currently selected
        if (self._appState.navSelection == nil) {
          return .sidebar
        }

        return .detail
      },
      set: { column in

        // Clear the nav selection if the
        // system navigates back to the sidebar
        if (column == .sidebar) {
          self._appState.navSelection = nil
        }
      }
    )
  }

  var body: some View {

    @Bindable
    var appState = _appState

    Group {
      if (self._taskSheets.isEmpty == true) {
        WelcomeView()
      }

      if (self._taskSheets.isEmpty == false) {
        NavigationSplitView(
          columnVisibility: $appState.navVisibility,
          preferredCompactColumn: self._navColumn,
          sidebar: {
            NavSidebarView(sizeClass: self._sizeClass)
          },
          detail: {
            NavRouterView(sizeClass: self._sizeClass)
              .containerBackground(Color.base, for: .navigation)
          }
        )
      }
    }
    .preferredColorScheme(self._appSettings.appearance.scheme)
    .tint(.accent)
  }
}
