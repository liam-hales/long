import LucideSwift
import SwiftUI

/// Used to display the edit view which allows
/// the user to update task sheet details
struct EditTaskSheetView: View {
  private static let _maxNameLength = 16
  private let _sheet: TaskSheetModel

  @Environment(\.dismiss)
  private var _dismiss: DismissAction

  @FocusState
  private var _isFocused: Bool

  @State
  private var _name: String

  /// Initialises the view with the
  /// task `sheet` to edit
  init(sheet: TaskSheetModel) {
    self._sheet = sheet
    self.__name = State(initialValue: sheet.name)
  }

  private var _trimmedName: String {
    self._name.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private var _isDisabled: Bool {
    (
      self._trimmedName.count > Self._maxNameLength ||
      self._trimmedName.isEmpty == true ||
      self._trimmedName == self._sheet.name
    )
  }

  /// Used to save the task sheet
  /// and dismiss the view
  private func _save() -> Void {
    self._sheet.rename(self._trimmedName)
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
                .font(.serif(17, .bold))
                .padding(.top, 2)
            }
            .padding(.horizontal, 8)
          }
          .buttonStyle(.glassProminent)
          .disabled(self._isDisabled)
          .tint(
            (self._isDisabled == true)
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
