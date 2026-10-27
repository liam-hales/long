import LucideSwift
import SwiftUI

/// Used to render the toolbar displayed above
/// the users tasks in the `TaskSheetView`
struct TaskSheetToolbar: ToolbarContent {
  private let _sheet: TaskSheetModel

  @Environment(AppState.self)
  private var _appState: AppState

  @State
  private var _showDeleteConfirmation: Bool = false

  /// Initialises the toolbar with
  /// the task `sheet` being viewed
  init(sheet: TaskSheetModel) {
    self._sheet = sheet
  }

  /// Used to delete the task sheet
  private func _delete() -> Void {
    self._appState.deleteTaskSheet(self._sheet)
  }

  var body: some ToolbarContent {

    @Bindable
    var appState = _appState

    ToolbarItem(placement: .topBarTrailing) {
      Menu(
        content: {
          Picker("Focus", selection: $appState.taskFocus) {
            ForEach(TaskFilter.allCases) { focus in
              Label(
                title: {
                  Text(focus.title)
                },
                icon: {
                  Image(
                    lucide: focus.icon,
                    size: .init(width: 22, height: 22)
                  )
                }
              )
            }
          }
          .tint(.contentPrimary)
          .pickerStyle(.inline)
        },
        label: {
          let isActive = (self._appState.taskFocus != .all)

          HStack(
            alignment: .center,
            spacing: 12
          ) {
            VStack(
              alignment: .leading,
              spacing: 1
            ) {
              Text("Focus on")
                .foregroundStyle(Color.contentSecondary)
                .font(.serif(11, .regular))

              Text(appState.taskFocus.title)
                .font(.serif(12, .semibold))
            }

            ZStack(alignment: .center) {
              if (isActive == true) {
                Circle()
                  .fill(Color.accent)
              }

              LucideIcon(
                self._appState.taskFocus.icon,
                size: 22,
                color: (isActive == true)
                  ? .white
                  : .contentPrimary
              )
            }
            .frame(
              width: 34,
              height: 34
            )
          }
          .padding(.leading, 8)
          .padding(.trailing, -4)
        }
      )
    }
    .toolbarAxis(.horizontal)

    ToolbarSpacer(
      .fixed,
      placement: .topBarTrailing
    )

    ToolbarItemGroup(placement: .topBarTrailing) {
      let undoManager = self._sheet.undoManager

      if (undoManager.canUndo == true) {
        Button(
          action: {
            undoManager.undo()
          },
          label: {
            LucideIcon(.undo2, size: 22)
          }
        )
      }

      if (undoManager.canRedo == true) {
        Button(
          action: {
            undoManager.redo()
          },
          label: {
            LucideIcon(.redo2, size: 22)
          }
        )
      }
    }
    .toolbarAxis(.vertical)

    ToolbarSpacer(
      .fixed,
      placement: .topBarTrailing
    )

    ToolbarItemGroup(placement: .topBarTrailing) {
      Button(
        action: {
          self._appState.modalSelection = .editTaskSheet
        },
        label: {
          LucideIcon(.pencil, size: 22)
        }
      )

      Button(
        role: .destructive,
        action: {
          self._showDeleteConfirmation = true
        },
        label: {
          LucideIcon(.trash, size: 22)
            .foregroundStyle(Color.contentError)
        }
      )
      .confirmationDialog(
        "Delete \"\(self._sheet.name)\"?",
        isPresented: self.$_showDeleteConfirmation,
        titleVisibility: .visible,
        actions: {
          Button(
            "Delete",
            role: .destructive,
            action: self._delete
          )
        },
        message: {
          Text("This task sheet and all of its tasks will be permanently deleted.")
        }
      )
    }
    .toolbarAxis(.vertical)
  }
}
