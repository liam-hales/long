import LucideSwift
import SwiftUI

/// Used to render an icon tile
/// in the accent colour
struct IconTileView: View {
  private let _icon: LucideIconName
  private let _size: CGFloat

  /// Initialises the view with the `icon`
  /// to render at the given `size`
  init(icon: LucideIconName, size: CGFloat) {
    self._icon = icon
    self._size = size
  }

  var body: some View {
    LucideIcon(
      self._icon,
      size: self._size,
      color: .accent
    )
    .padding(8)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(Color.surfaceAccent)
    )
  }
}
