import SwiftUI

/// Used to display the edit view which allows
/// the user to update their preferred name
struct EditNameView: View {
  private static let _maxNameLength = 24

  @Environment(AppSettings.self)
  private var _appSettings: AppSettings

  @FocusState
  private var _isFocused: Bool

  @State
  private var _name: String

  private var _trimmedName: String {
    self._name.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private var _hasChanges: Bool {
    self._trimmedName != self._appSettings.preferredName
  }

  private var _isNameValid: Bool {
    self._trimmedName.count <= Self._maxNameLength
  }

  /// Initialises the view with the
  /// current preferred `name` to edit
  init(name: String) {
    self.__name = State(initialValue: name)
  }

  var body: some View {
    EditView(
      subject: "name",
      height: 180,
      hasChanges: self._hasChanges,
      isValid: self._isNameValid,
      onSave: {
        self._appSettings.preferredName = self._trimmedName
      },
      content: {
        VStack(
          alignment: .leading,
          spacing: 8
        ) {
          TextField(
            "Name",
            text: self.$_name,
            prompt: Text("Name")
              .foregroundStyle(Color.contentSecondary)
          )
          .font(.serif(28, .semibold))
          .focused(self.$_isFocused)
          .textContentType(.givenName)
          .textInputAutocapitalization(.words)
          .autocorrectionDisabled()
          .submitLabel(.done)

          HStack(
            alignment: .center,
            spacing: 8
          ) {
            Text("The name used to greet you")
              .foregroundStyle(Color.contentSecondary)
              .font(.mono(14))

            Spacer()

            // Display the current name character
            // count so the user knows not to go over
            Text("\(self._trimmedName.count) / \(Self._maxNameLength)")
              .foregroundStyle(
                (self._isNameValid == false)
                  ? Color.contentError
                  : Color.contentSecondary
              )
              .font(.mono(14))
          }
        }
        .padding(.horizontal, 4)
        .onAppear {
          self._isFocused = true
        }
      }
    )
  }
}
