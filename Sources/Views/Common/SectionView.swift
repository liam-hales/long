import LucideSwift
import SwiftUI

/// Used to render a list section
/// with a custom header
struct SectionView<Content: View>: View {
  private let _title: String
  private let _icon: LucideIconName
  private let _count: Int?
  private let _headerColour: Color
  private let _content: Content

  private var _headerText: String {

    // Only append the count
    // if one has been set
    guard let count = self._count else {
      return self._title
    }

    return "\(self._title) • \(count)"
  }

  /// Initialises the view with the `content` to render
  /// with a given `title`, `icon` and optional `count`
  init(
    title: String,
    icon: LucideIconName,
    count: Int? = nil,
    headerColour: Color = .contentSecondary,

    @ViewBuilder
    content: () -> Content
  ) {
    self._title = title
    self._icon = icon
    self._count = count
    self._headerColour = headerColour
    self._content = content()
  }

  var body: some View {
    Section(
      content: {
        self._content
      },
      header: {
        HStack(
          alignment: .center,
          spacing: 6
        ) {
          LucideIcon(self._icon, size: 14)

          Text(self._headerText)
            .font(.mono(14))
        }
        .foregroundStyle(self._headerColour)
        .padding(.horizontal, 8)
      }
    )
  }
}
