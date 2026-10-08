import SwiftUI

extension View {

  /// Used to style a view as a standalone list
  /// row with its own padding and background
  func listRow(isSelected: Bool = false) -> some View {
    self.modifier(ListRowModifier(isSelected: isSelected))
  }
}
