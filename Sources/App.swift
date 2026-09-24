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
      self._container = try ModelContainer(for: TaskItem.self, TaskSheetItem.self);
      self.__appState = State(initialValue: AppState(context: self._container.mainContext));
    }
    catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
    
    // Configure the appearance
    // of some UIKit views
    self._configureNavBar();
  }
  
  /// Used to configure the `UINavigationBar`
  /// appearance for the app
  private func _configureNavBar() -> Void {
    let iconImage = Image(
      lucide: .arrowLeft,
      size: .init(width: 22, height: 22)
    );
    
    // Define the renderer and its scale
    // used to render the icon image
    let renderer = ImageRenderer(content: iconImage);
    renderer.scale = 3;
    
    let backImage = renderer.uiImage;
    let appearance = UINavigationBarAppearance();
    
    appearance.configureWithDefaultBackground();
    appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage);
    appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear];

    UINavigationBar.appearance().standardAppearance = appearance;
    UINavigationBar.appearance().scrollEdgeAppearance = appearance;
    UINavigationBar.appearance().compactAppearance = appearance;
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
