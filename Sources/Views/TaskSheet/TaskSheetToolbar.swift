import LucideSwift
import SwiftUI

/// Used to render the toolbar displayed above
/// the users tasks in the `TaskSheetView`
struct TaskSheetToolbar: ToolbarContent {
  private let _sheet: TaskSheetModel

  @Environment(AppState.self)
  private var _appState: AppState

  @State
  private var _showCompleteConfirmation: Bool = false

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
    .visibilityPriority(.high)

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
            Label(
              title: {
                Text("Undo")
              },
              icon: {
                Image(
                  lucide: .undo2,
                  size: .init(width: 22, height: 22)
                )
              }
            )
          }
        )
        .tint(.contentPrimary)
      }

      if (undoManager.canRedo == true) {
        Button(
          action: {
            undoManager.redo()
          },
          label: {
            Label(
              title: {
                Text("Redo")
              },
              icon: {
                Image(
                  lucide: .redo2,
                  size: .init(width: 22, height: 22)
                )
              }
            )
          }
        )
        .tint(.contentPrimary)
      }
    }
    .toolbarAxis(.vertical)

    ToolbarSpacer(
      .fixed,
      placement: .topBarTrailing
    )

    ToolbarItem(placement: .topBarTrailing) {
      Button(
        action: {
          self._appState.modalSelection = .editTaskSheet
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
    }
    .toolbarAxis(.vertical)

    ToolbarItem(placement: .topBarTrailing) {
      Button(
        action: {
          self._showCompleteConfirmation = true
        },
        label: {
          Label(
            title: {
              Text("Complete All")
            },
            icon: {
              Image(
                lucide: .checkCheck,
                size: .init(width: 22, height: 22)
              )
            }
          )
        }
      )
      .tint(.contentPrimary)
      .disabled(self._sheet.activeCount == 0)
      .confirmationDialog(
        "Complete all tasks?",
        isPresented: self.$_showCompleteConfirmation,
        titleVisibility: .visible,
        actions: {
          Button("Complete All") {
            self._sheet.completeAllTasks()
          }
        },
        message: {
          Text("All tasks in this task sheet will be marked as completed.")
        }
      )
    }
    .toolbarAxis(.vertical)
    .visibilityPriority(.low)

    ToolbarItem(placement: .topBarTrailing) {
      Button(
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
      .tint(.contentError)
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
    .visibilityPriority(.low)
  }
}
