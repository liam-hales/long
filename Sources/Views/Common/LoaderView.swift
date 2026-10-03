import LucideSwift
import SwiftUI

/// Used to render a loading spinner
/// to let the user know to wait
struct LoaderView: View {
  private let _size: CGFloat

  /// Initialises the view with an
  /// optional `size` for the icon
  init(size: CGFloat = 22) {
    self._size = size
  }

  var body: some View {
    LucideIcon(
      .loaderCircle,
      size: self._size
    )
    .keyframeAnimator(
      initialValue: Angle.zero,
      repeating: true,
      content: { content, angle in
        content.rotationEffect(angle)
      },
      keyframes: { _ in
        LinearKeyframe(Angle.degrees(360), duration: 0.8)
      }
    )
  }
}
