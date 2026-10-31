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
}
