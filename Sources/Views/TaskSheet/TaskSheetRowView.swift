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
    HStack(
      alignment: .center,
      spacing: 8
    ) {
      Text(self._sheet.name)
        .lineLimit(1)
        .frame(
          maxWidth: .infinity,
          alignment: .leading
        )

      if (self._sheet.overdueCount > 0) {
        LucideIcon(
          TaskFilter.overdue.icon,
          size: 16,
          color: .contentError
        )
      }

      if (self._sheet.todayCount > 0) {
        LucideIcon(
          TaskFilter.today.icon,
          size: 16,
          color: .contentWarning
        )
      }

      Text("\(self._sheet.activeCount)")
        .foregroundStyle(Color.contentSecondary)
        .font(.mono(12))
    }
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
