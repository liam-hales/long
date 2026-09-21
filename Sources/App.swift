import SwiftUI
import SwiftData

/// The main entry point to the
/// entire application
@main
struct App: SwiftUI.App {
  private let _container: ModelContainer;

  @State
  private var _appState: AppState;

  /// Initialises the app with new app state
  /// and custom appearance configuration
  init() {
    do {
      self._container = try ModelContainer(for: TaskItem.self);
      self.__appState = State(initialValue: AppState(context: self._container.mainContext));
    }
    catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }

  var body: some Scene {
    WindowGroup {
      AppView()
        .font(.serif(17, .regular))
        .tint(.contentPrimary)
        .foregroundStyle(Color.contentPrimary);
    }
    .modelContainer(self._container)
    .environment(self._appState);
  }
}
