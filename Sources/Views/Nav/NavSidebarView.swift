import LucideSwift
import SwiftUI

/// Used to display the navigation sidebar for the app which
/// renders the home view and split view specific controls
struct NavSidebarView: View {
  private let _sizeClass: UserInterfaceSizeClass?

  @Environment(AppState.self)
  private var _appState: AppState

  @Environment(\.displayScale)
  private var _displayScale: CGFloat

  /// Initialises the view with
  /// the app `sizeClass`
  init(sizeClass: UserInterfaceSizeClass?) {
    self._sizeClass = sizeClass
  }

  var body: some View {
    HomeView()
      .toolbar(removing: .sidebarToggle)
      .toolbar {

        // Show the sidebar open button only if the size class is set to `regular` and
        // the primary action placement keeps it after the home view toolbar items
        if (self._sizeClass == .regular) {
          ToolbarSpacer(
            .fixed,
            placement: .primaryAction
          )

          ToolbarItem(placement: .primaryAction) {
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
      }
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
