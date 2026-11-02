import SwiftUI

/// Used to display the header at the top of the navigation
/// sidebar, greeting the user and displaying today's date
struct NavHeaderView: View {
  private static let _greetingSeed: Int = Int.random(in: 0...Int.max)

  @Environment(AppSettings.self)
  private var _appSettings: AppSettings

  /// Used to force the view to rebuild when the
  /// app comes back from the background
  @Environment(\.scenePhase)
  private var _scenePhase: ScenePhase

  /// The title greeting to the user for the current time
  /// of day which uses their preferred name if it's set
  private var _title: String {
    Greeting(date: .now).text(
      seed: Self._greetingSeed,
      name: self._appSettings.preferredName
    )
  }

  /// The subtitle which will always be today's date written
  /// out in full e.g. "Wednesday, 21 October 2026"
  private var _subtitle: String {
    Date.now.formatted(date: .complete, time: .omitted)
  }

  var body: some View {
    VStack(
      alignment: .center,
      spacing: 4
    ) {
      Text(self._title)
        .font(.serif(28, .semibold))
        .multilineTextAlignment(.center)

      Text(self._subtitle)
        .foregroundStyle(Color.contentSecondary)
        .font(.mono(14))
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 12)
    .listRowInsets(.vertical, 0)
    .listRowBackground(Color.clear)
    .listRowSeparator(.hidden)
  }
}
