import SwiftUI

/// Used to render a single settings
/// row for the settings list
struct SettingsRowView<Content: View>: View {
  private let _title: String
  private let _subtitle: String
  private let _content: Content

  /// Initialises the view with the `title` and `subtitle`
  /// to render and the `content` used to change the setting
  init(
    title: String,
    subtitle: String,

    @ViewBuilder
    content: () -> Content
  ) {
    self._title = title
    self._subtitle = subtitle
    self._content = content()
  }

  var body: some View {
    HStack(
      alignment: .center,
      spacing: 10
    ) {
      VStack(
        alignment: .leading,
        spacing: 4
      ) {
        Text(self._title)
          .font(.serif(16, .semibold))
        Text(self._subtitle)
          .font(.mono(11))
          .foregroundStyle(Color.contentSecondary)
      }

      Spacer()

      self._content
    }
    .padding(.horizontal, 6)
    .listRow()
  }
}
