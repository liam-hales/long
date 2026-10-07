import SwiftUI

extension View {

  /// Used to style a view as a standalone list
  /// item with its own padding and background
  func listItem(isSelected: Bool = false) -> some View {
    self.modifier(ListItemModifier(isSelected: isSelected))
  }
}
