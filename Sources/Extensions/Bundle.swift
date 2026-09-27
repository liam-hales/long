import Foundation

extension Bundle {

  /// The app version number
  /// e.g. `1.0.0`
  var appVersion: String {
    self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
  }

  /// The app build
  /// number e.g. `1`
  var appBuild: String {
    self.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "Unknown"
  }
}
