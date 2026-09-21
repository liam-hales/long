import SwiftUI;

extension Font {
  
  enum FontFamily {
    case serif;
    case mono;
  }
  
  enum FontWeight {
    case regular;
    case bold;
  }
  
  /// Creates the app serif font at
  /// a fixed `size` and `weight`
  static func serif(_ size: CGFloat, _ weight: FontWeight = .regular) -> Font {
    let name = self._getName(
      family: .serif,
      weight: weight
    );
    
    return .custom(name, fixedSize: size);
  }
  
  /// Creates the app mono font
  /// at a fixed `size`
  static func mono(_ size: CGFloat) -> Font {
    let name = self._getName(
      family: .serif,
      weight: .regular
    );
    
    return .custom(name, fixedSize: size);
  }
  
  /// Resolves the custom font name for a
  /// given font `family` and `weight`
  private static func _getName(family: FontFamily, weight: FontWeight) -> String {
    switch (family, weight) {
      
      // For all the
      // serif fonts
      case (.serif, .regular): "Newsreader14pt-Regular";
      case (.serif, .bold): "Newsreader14pt-SemiBold";
      
      // For all the
      // mono fonts
      case (.mono, _): "JetBrainsMono-Medium";
    }
  }
}
