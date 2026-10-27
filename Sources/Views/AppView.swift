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
          sidebar: {
            NavSidebarView(sizeClass: self._sizeClass)
          },
          detail: {
            NavRouterView(sizeClass: self._sizeClass)
          }
        )
      }
    }
    .preferredColorScheme(self._appSettings.appearance.scheme)
    .tint(.accent)
  }
}
