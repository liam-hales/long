import SwiftUI

/// The main entry point view
/// rendered by the `App`
struct AppView: View {
  
  @Environment(AppState.self)
  private var _appState: AppState;

  @Environment(\.horizontalSizeClass)
  private var _sizeClass: UserInterfaceSizeClass?;

  var body: some View {
    
    @Bindable
    var appState = _appState;
    
    NavigationSplitView(
      columnVisibility: $appState.navVisibility,
      sidebar: {
        NavSidebarView(sizeClass: self._sizeClass);
      },
      detail: {
        NavRouterView(sizeClass: self._sizeClass);
      }
    )
    .tint(.accent);
  }
}
