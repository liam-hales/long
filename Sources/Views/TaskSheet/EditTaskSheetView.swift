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

  @State
  private var _showDiscardConfirmation: Bool = false

  private var _trimmedName: String {
    self._name.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private var _hasChanges: Bool {
    self._trimmedName != self._sheet.name
  }

  private var _isNameValid: Bool {
    (
      self._trimmedName.count <= Self._maxNameLength &&
      self._trimmedName.isEmpty == false
    )
  }

  private var _isSaveDisabled: Bool {
    (
      self._hasChanges == false ||
      self._isNameValid == false
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
    self._sheet.rename(to: self._trimmedName)
    self._dismiss()
  }

  /// Used to dismiss the view or confirm with
  /// the user first if they have unsaved changes
  private func _close() -> Void {

    // If the user has edited the name then
    // confirm before discarding the changes
    if (self._hasChanges == true) {
      self._showDiscardConfirmation = true
      return
    }

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
        .font(.serif(28, .semibold))
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
            action: self._close
          ) {
            LucideIcon(.x, size: 22)
          }
          .confirmationDialog(
            "Discard changes?",
            isPresented: self.$_showDiscardConfirmation,
            titleVisibility: .visible,
            actions: {
              Button(
                "Discard Changes",
                role: .destructive
              ) {
                self._dismiss()
              }
            },
            message: {
              Text("Your changes to this task sheet will be lost.")
            }
          )
        }

        ToolbarItem(placement: .confirmationAction) {
          Button(
            action: self._save
          ) {
            HStack(
              alignment: .center,
              spacing: 8
            ) {
              LucideIcon(
                .check,
                size: 20,
                strokeWidth: 3
              )

              Text("Save")
                .font(.serif(16, .semibold))
            }
            .padding(.horizontal, 6)
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
      .interactiveDismissDisabled(self._hasChanges)
    }
    .presentationBackground(Color.base)
    .presentationDetents([
      .height(180)
    ])
  }
}
