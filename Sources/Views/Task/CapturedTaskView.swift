import LucideSwift
import SwiftUI

/// Used to render a single captured
/// task for the user to review
struct CapturedTaskView: View {
  private let _task: TaskModel

  /// Initialises the view with
  /// the `task` to render
  init(task: TaskModel) {
    self._task = task
  }

  private var _opacity: Double {
    (self._task.reviewStatus == .confirmed)
      ? 1
      : 0.7
  }

  var body: some View {
    HStack(
      alignment: .top,
      spacing: 14
    ) {
      Button(
        action: {
          self._task.toggleConfirmed()
        },
        label: {
          ZStack(alignment: .center) {
            if (self._task.reviewStatus == .confirmed) {
              RoundedRectangle(cornerRadius: 6)
                .fill(Color.accent)

              LucideIcon(
                .check,
                size: 12,
                strokeWidth: 4
              )
              .foregroundStyle(.white)
              .padding(.top, 1)
            }

            if (self._task.reviewStatus == .confirmed) {
              RoundedRectangle(cornerRadius: 6)
                .strokeBorder(Color.outline, lineWidth: 1.5)
            }
          }
          .frame(width: 20, height: 20)
          .contentShape(.rect(cornerRadius: 6))
        }
      )
      .buttonStyle(.plain)

      VStack(
        alignment: .leading,
        spacing: 6
      ) {
        Text(self._task.title)
          .foregroundStyle(
            (self._task.reviewStatus == .confirmed)
              ? Color.contentPrimary
              : Color.contentSecondary
          )

        Text(self._task.subtitle)
          .foregroundStyle(Color.contentSecondary)
          .font(.mono(11))
      }
    }
    .listRow()
    .opacity(self._opacity)
  }
}
