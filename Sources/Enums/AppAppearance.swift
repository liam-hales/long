import LucideSwift
import SwiftUI

/// Describes the different appearances the
/// user can choose to display the app in
enum AppAppearance: String, CaseIterable, Identifiable {
  case light = "light"
  case dark = "dark"
  case system = "system"

  var id: Self {
    self
  }

  /// Describes the app
  /// appearance title
  var title: String {
    switch self {
      case .light: "Light"
      case .dark: "Dark"
      case .system: "System"
    }
  }

  /// Describes the app
  /// appearance icon
  var icon: LucideIconName {
    switch self {
      case .light: .sun
      case .dark: .moon
      case .system: .monitor
    }
  }

  /// Describes the colour scheme for the app
  /// appearance, `nil` follows the system
  var scheme: ColorScheme? {
    switch self {
      case .light: .light
      case .dark: .dark
      case .system: nil
    }
  }
}
