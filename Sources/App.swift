import SwiftData
import SwiftUI

/// The main entry point to the
/// entire application
@main
struct App: SwiftUI.App {
  private let _container: ModelContainer
  private let _captureManager: TaskCaptureManager
  private let _notificationManager: TaskNotificationManager

  @Environment(\.scenePhase)
  private var _scenePhase: ScenePhase

  @State
  private var _appState: AppState

  @State
  private var _appSettings: AppSettings

  /// Initialises the app with new app state,
  /// settings and custom appearance configuration
  init() {
    let appSettings = AppSettings()

    do {
      self._container = try ModelContainer(for: TaskModel.self, TaskSheetModel.self)
    }
    catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }

    self._captureManager = TaskCaptureManager()
    self._notificationManager = TaskNotificationManager(
      context: self._container.mainContext,
      appSettings: appSettings
    )

    // Cleanup any stored model data which
    // should be removed on app launch
    self._container.mainContext.cleanup()

    let appState = AppState(
      context: self._container.mainContext,
      captureManager: self._captureManager
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
    .onChange(
      of: self._scenePhase,
      initial: true
    ) { _, phase in

      // Ask for notification permission
      // when the app is opened and active
      if (phase == .active) {
        Task {
          await self._notificationManager.requestAuth()
        }
      }

      // Rebuild the notification summaries when the app is put in the
      // background since any task changes will have happened by then
      if (phase == .background) {
        self._notificationManager.schedule()
      }
    }
  }
}
