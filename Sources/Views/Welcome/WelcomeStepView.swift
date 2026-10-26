import SwiftUI

/// Used to render a single getting
/// started step for the welcome view
struct WelcomeStepView: View {
  private let _number: Int
  private let _title: String
  private let _message: String

  /// Initialises the view with the step `number`
  /// along with its `title` and `message`
  init(
    number: Int,
    title: String,
    message: String
  ) {
    self._number = number
    self._title = title
    self._message = message
  }

  var body: some View {
    HStack(
      alignment: .top,
      spacing: 14
    ) {
      Text("\(self._number)")
        .foregroundStyle(Color.contentSecondary)
        .font(.mono(12))
        .frame(width: 24, height: 24)
        .background(
          Circle()
            .fill(Color.surfaceMid)
            .strokeBorder(Color.outline, lineWidth: 1)
        )

      VStack(
        alignment: .leading,
        spacing: 6
      ) {
        Text(self._title)
          .font(.serif(16, .semibold))

        Text(self._message)
          .foregroundStyle(Color.contentSecondary)
          .font(.serif(14, .regular))
          .lineHeight(.multiple(factor: 1.4))
      }
      .padding(.top, 1)
    }
  }
}
