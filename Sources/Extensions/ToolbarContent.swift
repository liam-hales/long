import SwiftUI

extension ToolbarContent {

  /// Used to set which toolbar the item
  /// is placed in on iPhone Duo
  ///
  /// - `horizontal` keeps it in the horizontal bars
  /// - `vertical` prefers the vertical bar when there is one
  @ToolbarContentBuilder
  func toolbarAxis(_ axis: Axis) -> some ToolbarContent {

    // The `axisBehavior` modifier is
    // only aviliable on iOS 27.1
    if #available(iOS 27.1, *) {
      self.axisBehavior(
        (axis == .vertical)
          ? .verticalPreferred
          : .horizontalOnly
      )
    }

    if #unavailable(iOS 27.1) {
      self
    }
  }
}
