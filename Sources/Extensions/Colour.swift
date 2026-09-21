import SwiftUI

extension Color {

  static let accent = Color(light: "#cc785c", dark: "#cc785c");
  static let contentPrimary = Color(light: "#141413", dark: "#faf9f5");
  static let contentSecondary = Color(light: "#8e8b82", dark: "#a09d96");
  static let outline = Color(light: "#e6dfd8", dark: "#2a2825");
  static let base = Color(light: "#faf9f5", dark: "#181715");

  /// Initialises a `Color` from its hex value for
  /// both light and dark appearance
  init(light: String, dark: String) {
    let colour = UIColor { traits in

      // Get the correct RGB colour value
      // depending on the appearance
      let (red, green, blue) = (traits.userInterfaceStyle == .light)
        ? Color._toRGB(from: light)
        : Color._toRGB(from: dark);

      return UIColor(
        red: red,
        green: green,
        blue: blue,
        alpha: 1
      );
    };

    self.init(uiColor: colour);
  }

  /// Used to convert a given `hex` string into
  /// separate RGB colour values
  private static func _toRGB(from hex: String) -> (Double, Double, Double) {

    // Extract the colour segment
    // of the hex string
    let colour = hex
      .trimmingCharacters(in: .whitespaces)
      .dropFirst();

    if (colour.count != 6) {
      preconditionFailure("Invalid hex colour: \(hex)");
    }

    // Extract the colour value
    // from the colour string
    guard let value = UInt32(colour, radix: 16) else {
      preconditionFailure("Invalid hex colour: \(hex)");
    }

    // Return the RGB colour values
    return (
      Double((value >> 16) & 0xFF) / 255,
      Double((value >> 8) & 0xFF) / 255,
      Double(value & 0xFF) / 255
    )
  }
}
