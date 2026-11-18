import SwiftUI

extension EnvironmentValues {

  /// Used to determine if the system places a vertical
  /// bar in the current context e.g. on iPhone Duo
  nonisolated var hasVerticalBar: Bool {

    // The `toolbarVerticalEdge` value is
    // only available on iOS 27.1
    if #available(iOS 27.1, *) {
      return self.toolbarVerticalEdge != nil
    }

    return false
  }

  /// Used to determine which horizontal edge the system
  /// places the vertical bar on in the current context
  nonisolated var verticalBarEdge: Edge.Set {

    // The `toolbarVerticalEdge` value is
    // only available on iOS 27.1
    if #available(iOS 27.1, *) {
      switch self.toolbarVerticalEdge {

        case .leading:
          return .leading

        case .trailing:
          return .trailing

        // If there is no vertical edge
        // then return no edges
        case nil:
          return []
      }
    }

    return []
  }
}
