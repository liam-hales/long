import SwiftUI

/// Used to display a message when there
/// is no content to show the user
struct NoContentView: View {
  private let _title: String
  private let _message: String

  /// Initialises the view with a
  /// given `title` and `message`
  init(title: String, message: String) {
    self._title = title
    self._message = message
  }

  var body: some View {
    VStack(
      alignment: .center,
      spacing: 8
    ) {
      Text(self._title)
        .font(.serif(22, .bold))

      Text(self._message)
        .foregroundStyle(Color.contentSecondary)
        .font(.serif(14, .regular))
        .lineHeight(.multiple(factor: 1.4))
        .frame(maxWidth: 260)
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 20)
    .listRowBackground(Color.clear)
    .listRowSeparator(.hidden)
    .listRowInsets(.horizontal, 0)
  }
}
