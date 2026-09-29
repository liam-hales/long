import LucideSwift
import SwiftUI

/// Used to display the task input the
/// user can use to create tasks
struct TaskInputView: View {

  @Environment(\.displayScale)
  private var _displayScale: CGFloat

  @State
  private var _inputValue: String = ""

  private var _isDisabled: Bool {
    self._inputValue
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .isEmpty
  }

  var body: some View {
    VStack(
      alignment: .center,
      spacing: 0
    ) {
      Rectangle()
        .fill(Color.outline)
        .frame(height: 2 / self._displayScale)
        .allowsHitTesting(false)

      VStack(
        alignment: .center,
        spacing: 12
      ) {
        HStack(
          alignment: .bottom,
          spacing: 8
        ) {
          TextField(
            "Add tasks",
            text: self.$_inputValue,
            prompt: Text("What do you need to get done?")
              .foregroundStyle(Color.contentSecondary),
            axis: .vertical
          )
          .padding(.leading, 8)
          .padding(.vertical, 8)
          .lineLimit(8)

          Button(
            action: {},
            label: {
              LucideIcon(.arrowUp, size: 22)
                .frame(width: 14, height: 22)
                .foregroundStyle(
                  (self._isDisabled == true)
                    ? .contentSecondary
                    : .white
                )
            }
          )
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.roundedRectangle(radius: 10))
          .disabled(self._isDisabled)
          .tint(
            (self._isDisabled == true)
              ? .disabled
              : .accent
          )
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(
          RoundedRectangle(cornerRadius: 14)
            .fill(Color.surfaceHigh)
            .strokeBorder(Color.outline, lineWidth: 1)
        )

        Text("Capturing tasks uses Apple Intelligence which can make mistakes. Review tasks before they are added.")
          .font(.serif(14, .regular))
          .lineHeight(.multiple(factor: 1.4))
          .foregroundStyle(Color.contentSecondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 6)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 16)
    }
    .background {
      Color.base
        .ignoresSafeArea(edges: .bottom)
    }
  }
}
