import LucideSwift
import SwiftUI

/// Used to render a single
/// task row for the task lists
struct TaskRowView: View {
  private let _task: TaskModel
  private let _dateFormat: DateFormat
  private let _isSelected: Bool

  @Environment(AppState.self)
  private var _appState: AppState

  /// Initialises the view with the `task` to render,
  /// along with the `dateFormat` and `isSelected`
  init(
    task: TaskModel,
    dateFormat: DateFormat,
    isSelected: Bool = false
  ) {
    self._task = task
    self._dateFormat = dateFormat
    self._isSelected = isSelected
  }

  private var _badgeAppearance: BadgeView.Appearance {
    switch self._task.schedule {
      case .overdue: .error
      case .today: .warning
      case .scheduled: .info
      case .unscheduled: .info
    }
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
            if (self._task.isCompleted == true) {
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

            if (self._task.isCompleted == false) {
              Circle()
                .strokeBorder(Color.outline, lineWidth: 1.5)
            }
          }
          .frame(width: 20, height: 20)
          .contentShape(.circle)
        }
      )
      .buttonStyle(.plain)

      VStack(
        alignment: .leading,
        spacing: 8
      ) {
        let title = self._task.title
        let subtitle = self._task.subtitle(
          dateFormat: self._dateFormat
        )

        Text(title)
          .strikethrough(self._task.isCompleted)
          .foregroundStyle(
            (self._task.isCompleted == true)
              ? Color.contentSecondary
              : Color.contentPrimary
          )

        if (self._task.isCompleted == true) {
          Text(subtitle)
            .foregroundStyle(Color.contentSecondary)
            .font(.mono(11))
        }

        if (self._task.isCompleted == false) {
          BadgeView(
            appearance: self._badgeAppearance,
            text: subtitle
          )
        }
      }
    }
    .listRow(isSelected: self._isSelected)
    .contentShape(
      .contextMenuPreview,
      .rect(cornerRadius: 14)
    )
    .contextMenu {
      Button(
        action: {
          self._task.toggleCompleted()
        },
        label: {
          Label(
            title: {
              Text(
                (self._task.isCompleted == true)
                  ? "Uncomplete"
                  : "Complete"
              )
            },
            icon: {
              Image(
                lucide: (self._task.isCompleted == true)
                  ? LucideIconName.x
                  : .check,
                size: .init(width: 22, height: 22)
              )
            }
          )
        }
      )
      .tint(.contentPrimary)

      Button(
        action: {
          self._appState.modalSelection = .editTask(self._task)
        },
        label: {
          Label(
            title: {
              Text("Edit")
            },
            icon: {
              Image(
                lucide: .pencil,
                size: .init(width: 22, height: 22)
              )
            }
          )
        }
      )
      .tint(.contentPrimary)

      Button(
        action: {
          self._task.sheet?.removeTasks([self._task])
        },
        label: {
          Label(
            title: {
              Text("Delete")
            },
            icon: {
              Image(
                lucide: .trash,
                size: .init(width: 22, height: 22)
              )
            }
          )
        }
      )
      .tint(.contentPrimary)
    }
  }
}
