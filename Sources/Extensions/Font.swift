import SwiftUI

extension Font {

  /// Creates the app serif font (New York)
  /// at a fixed `size` and `weight`
  static func serif(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
    .system(
      size: size,
      weight: weight,
      design: .serif
    )
  }

  /// Creates the app mono font
  /// (JetBrains Mono) at a fixed `size`
  static func mono(_ size: CGFloat) -> Font {
    .custom("JetBrainsMono-Medium", fixedSize: size)
  }

  /// Creates the app logo font
  /// (SixCaps) at a fixed `size`
  static func logo(_ size: CGFloat) -> Font {
    .custom("SixCaps", fixedSize: size)
  }
}
