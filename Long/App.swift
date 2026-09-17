import SwiftUI
import SwiftData

/// The main entry point to the
/// entire application
@main
struct App: SwiftUI.App {

  @State
  private var appState: AppState;

  /// Initialises the app with new
  // non-persistent app state
  init() {
    self.appState = AppState();
  }

  var body: some Scene {
    WindowGroup {
      AppView();
    }
    .environment(appState);
  }
}
