import LucideSwift
import SwiftUI

/// Used to render a single task sheet
/// row for the task sheet list
struct TaskSheetRowView: View {
  private let _sheet: TaskSheetModel
  private let _isSelected: Bool

  @Environment(AppState.self)
  private var _appState: AppState

  @State
  private var _showDeleteConfirmation: Bool = false

  /// Initialises the view with the given
  /// task `sheet` to render
  init(sheet: TaskSheetModel, isSelected: Bool) {
    self._sheet = sheet
    self._isSelected = isSelected
  }

  var body: some View {
    VStack(
      alignment: .leading,
      spacing: 8
    ) {
      Text(self._sheet.name)

      HStack(
        alignment: .center,
        spacing: 8
      ) {
        if (self._sheet.overdueCount > 0) {
          BadgeView(
            appearance: .error,
            text: "\(self._sheet.overdueCount)",
            icon: TaskFilter.overdue.icon
          )
        }

        if (self._sheet.todayCount > 0) {
          BadgeView(
            appearance: .warning,
            text: "\(self._sheet.todayCount)",
            icon: TaskFilter.today.icon
          )
        }

        if (
          self._sheet.overdueCount > 0 ||
          self._sheet.todayCount > 0
        ) {
          Text("•")
            .foregroundStyle(Color.contentSecondary)
            .font(.mono(11))
        }

        Text("\(self._sheet.activeCount) \((self._sheet.activeCount == 1) ? "task" : "tasks") to complete")
          .foregroundStyle(Color.contentSecondary)
          .font(.mono(11))
      }
    }
    .padding(.leading, 6)
    .listRow(isSelected: self._isSelected)
    .contentShape(
      .contextMenuPreview,
      .rect(cornerRadius: 14)
    )
    .contextMenu {
      Button(
        action: {
          self._appState.modalSelection = .editTaskSheet(self._sheet)
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
        role: .destructive,
        action: {
          self._showDeleteConfirmation = true
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
      .tint(.red)
    }
    .confirmationDialog(
      "Delete \"\(self._sheet.name)\"?",
      isPresented: self.$_showDeleteConfirmation,
      titleVisibility: .visible,
      actions: {
        Button(
          "Delete",
          role: .destructive,
        ) {
          self._appState.deleteTaskSheet(self._sheet)
        }
      },
      message: {
        Text("This task sheet and all of its tasks will be permanently deleted.")
      }
    )
  }
}
