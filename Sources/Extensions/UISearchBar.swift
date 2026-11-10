import SwiftUI

extension UISearchBar {

  /// Used to configure the `UISearchBar`
  /// scope bar appearance for the app
  static func configureAppearance() -> Void {
    let scopeDescriptor = UIFont
      .systemFont(ofSize: 13, weight: .regular)
      .fontDescriptor
      .withDesign(.serif)

    let scopeSelectedDescriptor = UIFont
      .systemFont(ofSize: 13, weight: .semibold)
      .fontDescriptor
      .withDesign(.serif)

    guard
      let scopeDescriptor,
      let scopeSelectedDescriptor
    else {
      preconditionFailure("Failed to create fonts for \"UISearchBar\"")
    }

    // Create the scope fonts from the descriptors
    // for the normal and selected states
    let scopeFont = UIFont(descriptor: scopeDescriptor, size: 14)
    let scopeSelectedFont = UIFont(descriptor: scopeSelectedDescriptor, size: 14)

    // Configure the appearance scope
    // bar title text attributes
    self
      .appearance()
      .setScopeBarButtonTitleTextAttributes(
        [
          .font: scopeFont,
          .foregroundColor: UIColor(Color.contentSecondary),
        ],
        for: .normal
      )

    self
      .appearance()
      .setScopeBarButtonTitleTextAttributes(
        [
          .font: scopeSelectedFont,
          .foregroundColor: UIColor(Color.contentPrimary),
        ],
        for: .selected
      )
  }
}
