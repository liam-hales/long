import SwiftUI

/// Used to display the edit view which allows
/// the user to update task sheet details
struct EditTaskSheetView: View {
  private static let _maxNameLength = 24
  private let _sheet: TaskSheetModel

  @FocusState
  private var _isFocused: Bool

  @State
  private var _name: String

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

  /// Initialises the view with the
  /// task `sheet` to edit
  init(sheet: TaskSheetModel) {
    self._sheet = sheet
    self.__name = State(initialValue: sheet.name)
  }

  var body: some View {
    EditView(
      subject: "task sheet",
      height: 180,
      hasChanges: self._hasChanges,
      isValid: self._isNameValid,
      onSave: {
        self._sheet.rename(to: self._trimmedName)
      },
      content: {
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
          // count so the user knows not to go over
          Text("\(self._trimmedName.count) / \(Self._maxNameLength)")
            .foregroundStyle(
              (self._trimmedName.count > Self._maxNameLength)
                ? Color.contentError
                : Color.contentSecondary
            )
            .font(.mono(14))
        }
        .padding(.horizontal, 4)
        .onAppear {
          self._isFocused = true
        }
      }
    )
  }
}
