import SwiftUI

/// Used to style a view as a standalone list
/// item with its own padding and background
struct ListItemModifier: ViewModifier {
  private let _isSelected: Bool

  init(isSelected: Bool) {
    self._isSelected = isSelected
  }

  func body(content: Content) -> some View {
    content
      .padding(.horizontal, 14)
      .padding(.vertical, 14)
      .frame(
        maxWidth: .infinity,
        alignment: .leading
      )
      .background(
        RoundedRectangle(cornerRadius: 14)
          .fill(Color.surfaceHigh)
          .strokeBorder(
            (self._isSelected == true)
              ? Color.outlineSelected
              : Color.outline,
            lineWidth: 1
          )
      )
      .listRowInsets(EdgeInsets())
      .listRowBackground(Color.clear)
  }
}
