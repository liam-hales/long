import LucideSwift
import SwiftUI

/// Used to render a single
/// task item for the task lists
struct TaskView: View {
  private let _task: TaskModel

  /// Initialises the view with
  /// the `task` to render
  init(task: TaskModel) {
    self._task = task
  }

  var body: some View {
    HStack(
      alignment: .top,
      spacing: 14
    ) {
      Button(
        action: {
          self._task.toggleCompleted()
        },
        label: {
          ZStack(alignment: .center) {
            if (self._task.isCompleted) {
              Circle()
                .fill(Color.accent)

              LucideIcon(
                .check,
                size: 12,
                strokeWidth: 4
              )
              .foregroundStyle(.white)
              .padding(.top, 1)
            }

            if (!self._task.isCompleted) {
              Circle()
                .strokeBorder(Color.outline, lineWidth: 1.5)
            }
          }
          .frame(width: 20, height: 20)
          .contentShape(Circle())
        }
      )
      .buttonStyle(.plain)

      VStack(
        alignment: .leading,
        spacing: 6
      ) {
        Text(self._task.title)
          .strikethrough(self._task.isCompleted)
          .foregroundStyle(
            (self._task.isCompleted)
              ? Color.contentSecondary
              : Color.contentPrimary
          )
          .padding(.top, 3)

        Text(self._task.dueText)
          .foregroundStyle(Color.contentSecondary)
          .font(.mono(11))
      }
    }
    .listRowBackground(
      RoundedRectangle(cornerRadius: 14)
        .fill(Color.surfaceHigh)
        .strokeBorder(Color.outline, lineWidth: 1)
    )
  }
}
