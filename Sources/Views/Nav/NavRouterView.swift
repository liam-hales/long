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
        NoContentView(
          title: "Nothing selected.",
          message: "You have nothing selected, select a task sheet from the sidebar."
        )
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
    .sheet(item: $appState.modalSelection) { modal in
      switch modal {

        case .editTaskSheet:
          if let sheet = self._appState.selectedTaskSheet {
            EditTaskSheetView(sheet: sheet)
          }

        case .editTask: EmptyView()
        case .reviewTasks: EmptyView()
        case .settings: SettingsView()
      }
    }
  }
}
