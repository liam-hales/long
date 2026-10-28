import LucideSwift
import SwiftUI

/// Used to display a message when there
/// is no content to show the user
struct NoContentView: View {
  private let _title: String
  private let _message: String
  private let _icon: LucideIconName?

  /// Initialises the view with a given `title`
  /// and `message`, and an optional `icon`
  init(
    title: String,
    message: String,
    icon: LucideIconName? = nil
  ) {
    self._title = title
    self._message = message
    self._icon = icon
  }

  var body: some View {
    VStack(
      alignment: .center,
      spacing: 16
    ) {

      // Only render the icon
      // if it has been set
      if let icon = self._icon {
        LucideIcon(
          icon,
          size: 32,
          color: .contentSecondary
        )
      }

      VStack(
        alignment: .center,
        spacing: 8
      ) {
        Text(self._title)
          .font(.serif(22, .semibold))

        Text(self._message)
          .foregroundStyle(Color.contentSecondary)
          .font(.serif(14, .regular))
          .lineHeight(.multiple(factor: 1.4))
          .frame(maxWidth: 260)
          .multilineTextAlignment(.center)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 20)
    .listRowBackground(Color.clear)
    .listRowSeparator(.hidden)
  }
}
