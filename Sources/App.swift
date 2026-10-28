import SwiftData
import SwiftUI

/// The main entry point to the
/// entire application
@main
struct App: SwiftUI.App {
  private let _container: ModelContainer

  @State
  private var _appState: AppState

  @State
  private var _appSettings: AppSettings

  /// Initialises the app with new app state,
  /// settings and custom appearance configuration
  init() {
    let captureManager = TaskCaptureManager()
    let appSettings = AppSettings()

    do {
      self._container = try ModelContainer(for: TaskModel.self, TaskSheetModel.self)
    }
    catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }

    // Initialise the app state with the
    // context and capture manager
    let appState = AppState(
      context: self._container.mainContext,
      captureManager: captureManager
    )

    self.__appSettings = State(initialValue: appSettings)
    self.__appState = State(initialValue: appState)

    // Configure the appearance of some UIKit views
    // that don't have the required SwiftUI modifiers
    UINavigationBar.configureAppearance()
    UISearchBar.configureAppearance()
  }

  var body: some Scene {
    WindowGroup {
      AppView()
        .font(.serif(16, .regular))
        .tint(.contentPrimary)
        .foregroundStyle(Color.contentPrimary)
    }
    .modelContainer(self._container)
    .environment(self._appState)
    .environment(self._appSettings)
  }
}
