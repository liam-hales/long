import LucideSwift
import SwiftUI

/// Used to render a small rounded pill shaped
/// label made up of an icon and text
struct BadgeView: View {

  /// Describes the colour appearances
  /// the badge can be styled with
  enum Appearance {
    case info
    case warning
    case error
  }

  private let _appearance: Appearance
  private let _icon: LucideIconName
  private let _text: String

  private var _contentColour: Color {

    // Return the content colour
    // for the set appearances
    switch self._appearance {
      case .info: Color.contentSecondary
      case .warning: Color.contentWarning
      case .error: Color.contentError
    }
  }

  private var _surfaceColour: Color {

    // Return the surface colour
    // for the set appearances
    switch self._appearance {
      case .info: Color.surfaceMid
      case .warning: Color.surfaceWarning
      case .error: Color.surfaceError
    }
  }

  private var _outlineColour: Color {

    // Return the outline colour
    // for the set appearances
    switch self._appearance {
      case .info: Color.outline
      case .warning: Color.outlineWarning
      case .error: Color.outlineError
    }
  }

  /// Initialises the view with the `icon` and `text`
  /// to render, styled using the given `appearance`
  init(
    appearance: Appearance,
    icon: LucideIconName,
    text: String
  ) {
    self._appearance = appearance
    self._icon = icon
    self._text = text
  }

  var body: some View {
    HStack(
      alignment: .center,
      spacing: 4
    ) {
      LucideIcon(self._icon, size: 12)

      Text(self._text)
        .font(.mono(11))
    }
    .foregroundStyle(self._contentColour)
    .padding(.horizontal, 8)
    .padding(.vertical, 5)
    .background(
      RoundedRectangle(cornerRadius: 6)
        .fill(self._surfaceColour)
        .strokeBorder(self._outlineColour, lineWidth: 1)
    )
  }
}
