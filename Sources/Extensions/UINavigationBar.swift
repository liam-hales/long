import SwiftUI

extension UINavigationBar {

  /// Used to configure the `UINavigationBar`
  /// title and subtitle appearance for the app
  static func configureAppearance() -> Void {
    let titleDescriptor = UIFont
      .systemFont(ofSize: 18, weight: .semibold)
      .fontDescriptor
      .withDesign(.serif)

    guard
      let titleDescriptor,
      let subtitleFont = UIFont(name: "JetBrainsMono-Medium", size: 11)
    else {
      preconditionFailure("Failed to create fonts for \"UINavigationBar\"")
    }

    // Create the title font from the descriptor
    // and the new `UINavigationBar` appearance
    let titleFont = UIFont(descriptor: titleDescriptor, size: 18)
    let appearance = UINavigationBarAppearance()
    
    // Configure the appearance backgrond
    // and text attributes
    appearance.configureWithDefaultBackground()
    appearance.titleTextAttributes = [
      .font: titleFont,
      .foregroundColor: UIColor(Color.contentPrimary),
    ]

    appearance.subtitleTextAttributes = [
      .font: subtitleFont,
      .foregroundColor: UIColor(Color.contentSecondary),
    ]

    self.appearance().standardAppearance = appearance
    self.appearance().scrollEdgeAppearance = appearance
    self.appearance().compactAppearance = appearance
  }
}
