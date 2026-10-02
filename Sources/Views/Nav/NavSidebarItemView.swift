import LucideSwift
import SwiftUI

/// Used to render a navigation
/// link for the sidebar
struct NavSidebarItemView<Content: View>: View {
  private let _value: AppState.NavSelection
  private let _sizeClass: UserInterfaceSizeClass?
  private let _content: Content

  @Environment(AppState.self)
  private var _appState: AppState

  /// Initialises the view with the nav selection `value`, the app
  /// `sizeClass` and `content` to render as the label
  init(
    value: AppState.NavSelection,
    sizeClass: UserInterfaceSizeClass?,

    @ViewBuilder
    content: () -> Content
  ) {
    self._value = value
    self._sizeClass = sizeClass
    self._content = content()
  }

  var body: some View {
    NavigationLink(value: self._value) {
      HStack(
        alignment: .center,
        spacing: 16
      ) {
        self._content

        // Show the custom arrow icon only if
        // the size class is set to `compact`
        if (self._sizeClass == .compact) {
          Spacer()

          LucideIcon(.chevronRight, size: 20)
            .foregroundStyle(Color.contentSecondary)
        }
      }
    }
    .navigationLinkIndicatorVisibility(.hidden)
    .listRowBackground(
      RoundedRectangle(cornerRadius: 14)
        .fill(
          (self._appState.navSelection == self._value)
            ? Color.selected
            : Color.surfaceHigh
        )
        .strokeBorder(Color.outline, lineWidth: 1)
    )
  }
}
