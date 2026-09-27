import SwiftUI

extension UINavigationBar {

  /// Used to configure the `UINavigationBar`
  /// title and subtitle appearance for the app
  static func configureAppearance() -> Void {
    let titleName = Font.getName(
      family: .serif,
      weight: .bold
    )

    let subtitleName = Font.getName(
      family: .mono,
      weight: .regular
    )

    // Create the fonts used for the
    // nav bar title and subtitle
    guard
      let titleFont = UIFont(name: titleName, size: 18),
      let subtitleFont = UIFont(name: subtitleName, size: 11)
    else {
      preconditionFailure("Failed to create fonts for \"UINavigationBar\"")
    }

    // Define the attributes for the title
    // and subtitle inline appearance
    let appearance = UINavigationBarAppearance()
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
