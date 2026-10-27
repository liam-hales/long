import SwiftUI

extension View {

  /// Used to style a view as a standalone list
  /// row with its own padding and background
  func listRow(isSelected: Bool = false) -> some View {
    self.modifier(ListRowModifier(isSelected: isSelected))
  }

  /// Used to inset the view horizontally by the margins of its container,
  /// which account for the iPhone Duo vertical bar and different poses
  @ViewBuilder
  func containerMargins() -> some View {
    if #available(iOS 27.1, *) {
      self.contentMargins(for: .container, edges: .horizontal)
    }

    if #unavailable(iOS 27.1) {
      self.padding(.horizontal, 16)
    }
  }
}
