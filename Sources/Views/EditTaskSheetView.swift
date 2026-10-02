import LucideSwift
import SwiftUI

/// Used to display the edit view which allows
/// the user to update task sheet details
struct EditTaskSheetView: View {
  private static let _maxNameLength = 24
  private let _sheet: TaskSheetModel

  @Environment(\.dismiss)
  private var _dismiss: DismissAction

  @FocusState
  private var _isFocused: Bool

  @State
  private var _name: String

  @Environment(AppState.self)
  private var _appState: AppState

  @State
  private var _showDeleteConfirmation: Bool = false

  private var _trimmedName: String {
    self._name.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private var _isSaveDisabled: Bool {
    (
      self._trimmedName.count > Self._maxNameLength ||
      self._trimmedName.isEmpty == true ||
      self._trimmedName == self._sheet.name
    )
  }

  /// Initialises the view with the
  /// task `sheet` to edit
  init(sheet: TaskSheetModel) {
    self._sheet = sheet
    self.__name = State(initialValue: sheet.name)
  }

  /// Used to save the task sheet
  /// and dismiss the view
  private func _save() -> Void {
    self._sheet.rename(self._trimmedName)
    self._dismiss()
  }

  /// Used to delete the task sheet
  /// and dismiss the view
  private func _delete() -> Void {
    self._appState.deleteTaskSheet(self._sheet)
    self._dismiss()
  }

  var body: some View {
    NavigationStack {
      VStack(
        alignment: .leading,
        spacing: 8
      ) {
        TextField(
          "Name",
          text: self.$_name,
          prompt: Text("Untitled")
            .foregroundStyle(Color.contentSecondary)
        )
        .font(.serif(28, .bold))
        .focused(self.$_isFocused)
        .submitLabel(.done)

        // Display the current name character
        // count so the user knowsn not to go over
        Text("\(self._trimmedName.count) / \(Self._maxNameLength)")
          .foregroundStyle(
            (self._trimmedName.count > Self._maxNameLength)
              ? Color.contentError
              : Color.contentSecondary
          )
          .font(.mono(14))
      }
      .padding(.horizontal, 20)
      .padding(.top, 26)
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity,
        alignment: .topLeading
      )
      .onAppear {
        self._isFocused = true
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(
            action: {
              self._dismiss()
            },
            label: {
              LucideIcon(.x, size: 22)
            }
          )
        }

        ToolbarItem(placement: .topBarTrailing) {
          Menu(
            content: {
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
            },
            label: {
              LucideIcon(.ellipsis, size: 22)
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

        ToolbarSpacer(
          .fixed,
          placement: .topBarTrailing
        )

        ToolbarItem(placement: .confirmationAction) {
          Button(
            action: self._save
          ) {
            LucideIcon(
              .check,
              size: 20,
              strokeWidth: 3
            )
            .foregroundStyle(
              (self._isSaveDisabled == true)
                ? .contentSecondary
                : .white
            )
          }
          .buttonStyle(.glassProminent)
          .disabled(self._isSaveDisabled)
          .tint(
            (self._isSaveDisabled == true)
              ? .disabled
              : .accent
          )
        }
      }
      .navigationTitle("Edit")
      .navigationSubtitle("Update task sheet details")
      .navigationBarTitleDisplayMode(.inline)
    }
    .presentationBackground(Color.base)
    .presentationDetents([
      .height(180)
    ])
  }
}
