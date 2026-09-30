import LucideSwift
import SwiftUI

/// Used to route the user to the view
/// for the current navigation selections
struct NavRouterView: View {
  private let _sizeClass: UserInterfaceSizeClass?

  @Environment(AppState.self)
  private var _appState: AppState

  /// Initialises the view with
  /// the app `sizeClass`
  init(sizeClass: UserInterfaceSizeClass?) {
    self._sizeClass = sizeClass
  }

  var body: some View {

    @Bindable
    var appState = _appState

    Group {
      // If there is no nav selection then render a default
      // view to let the user know to select something
      if (self._appState.navSelection == nil) {
        VStack(
          alignment: .center,
          spacing: 6
        ) {
          Text("Nothing selected.")
            .font(.serif(22, .bold))
          Text("You have not selected an option from the sidebar.")
            .foregroundStyle(Color.contentSecondary)
            .font(.serif(14, .regular))
            .frame(maxWidth: 260)
            .multilineTextAlignment(.center)
        }
        .frame(
          maxWidth: .infinity,
          maxHeight: .infinity
        )
        .background(Color.base)
      }

      if let sheet = self._appState.selectedTaskSheet {
        TaskSheetView(sheet: sheet)
      }
    }
    .navigationBarBackButtonHidden(self._sizeClass == .compact)
    .toolbarTitleDisplayMode(.large)
    .toolbar {

      // Replace the system back button with a
      // custom one when the split view is collapsed
      if (self._sizeClass == .compact) {
        ToolbarItem(placement: .topBarLeading) {
          Button(
            action: {
              self._appState.navSelection = nil
            },
            label: {
              LucideIcon(.arrowLeft, size: 22)
            }
          )
        }
      }

      if (
        self._sizeClass == .regular &&
        self._appState.navVisibility == .detailOnly
      ) {
        ToolbarItem(placement: .topBarLeading) {
          Button(
            action: {
              self._appState.navVisibility = .doubleColumn
            },
            label: {
              LucideIcon(.panelRightClose, size: 22)
            }
          )
        }
      }
    }
    .sheet(item: $appState.sheetSelection) { sheet in
      switch sheet {
        case .editTaskSheet:
          if let taskSheet = self._appState.selectedTaskSheet {
            EditTaskSheetView(sheet: taskSheet)
          }

        case .editTask: EmptyView()
        case .reviewTasks: EmptyView()
        case .settings: SettingsView()
      }
    }
  }
}
