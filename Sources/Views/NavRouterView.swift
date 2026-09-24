import SwiftUI
import LucideSwift

/// Used to route the user to the view
/// for the current navigation selections
struct NavRouterView: View {
  private let _sizeClass: UserInterfaceSizeClass?;

  @Environment(AppState.self)
  private var _appState: AppState;

  /// Initialises the view with
  /// the app `sizeClass`
  init(sizeClass: UserInterfaceSizeClass?) {
    self._sizeClass = sizeClass;
  }

  var body: some View {
    NavigationStack {
      Group {

        // If there is no nav selection then render a default
        // view to let the user know to select something
        if (self._appState.navSelection == nil) {
          VStack(
            alignment: .center,
            spacing: 6
          ) {
            Text("Nothing selected.")
              .font(.serif(22, .bold));
            Text("You have not selected an option from the sidebar.")
              .foregroundStyle(Color.contentSecondary)
              .font(.serif(14, .regular))
              .frame(maxWidth: 260)
              .multilineTextAlignment(.center);
          }
          .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
          )
          .background(Color.base)
        }

        if let sheet = self._appState.selectedTaskSheet {
          TasksView(sheet: sheet);
        }

        if (self._appState.navSelection == .archived) {
          ArchivedView();
        }
      }
      .toolbar {
        if (
          self._sizeClass == .regular &&
          self._appState.navVisibility == .detailOnly
        ) {
          ToolbarItem(placement: .topBarLeading) {
            Button(
              action: {
                self._appState.navVisibility = .doubleColumn;
              },
              label: {
                LucideIcon(.panelRightClose, size: 22);
              }
            );
          }
        }
      };
    }
  }
}
