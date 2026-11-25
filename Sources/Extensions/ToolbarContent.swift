import SwiftUI

extension ToolbarContent {

  /// Used to set which toolbar the item
  /// is placed in on iPhone Duo
  ///
  /// - `horizontal` keeps it in the horizontal bars
  /// - `vertical` prefers the vertical bar when there is one
  @ToolbarContentBuilder
  func toolbarAxis(_ axis: Axis) -> some ToolbarContent {

    // The system `axisBehavior` modifier
    // is only available on iOS 27.1
    if #available(iOS 27.1, *) {
      let behavior: ToolbarItemAxisBehavior = switch axis {
        case .horizontal: .horizontalOnly
        case .vertical: .verticalPreferred
      }

      self.axisBehavior(behavior)
    }

    if #unavailable(iOS 27.1) {
      self
    }
  }
}
