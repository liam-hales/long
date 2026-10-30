import LucideSwift
import SwiftUI

/// Used to display a modal which allows the
/// user to edit and save a set of details
struct EditView<Content: View>: View {
  private let _subject: String
  private let _height: CGFloat
  private let _hasChanges: Bool
  private let _isValid: Bool
  private let _onSave: () -> Void
  private let _content: Content

  @Environment(\.dismiss)
  private var _dismiss: DismissAction

  @State
  private var _showDiscardConfirmation: Bool = false

  private var _isSaveDisabled: Bool {
    (
      self._hasChanges == false ||
      self._isValid == false
    )
  }

  /// Initialises the view with the edit `content` for a given
  /// `subject` and the `onSave` action to run when the user saves
  init(
    subject: String,
    height: CGFloat,
    hasChanges: Bool,
    isValid: Bool,
    onSave: @escaping () -> Void,

    @ViewBuilder
    content: () -> Content
  ) {
    self._subject = subject
    self._height = height
    self._hasChanges = hasChanges
    self._isValid = isValid
    self._onSave = onSave
    self._content = content()
  }

  /// Used to save the changes
  /// and dismiss the view
  private func _save() -> Void {
    self._onSave()
    self._dismiss()
  }

  /// Used to dismiss the view or confirm with
  /// the user first if they have unsaved changes
  private func _close() -> Void {

    // If the user has made changes then
    // confirm before discarding them
    if (self._hasChanges == true) {
      self._showDiscardConfirmation = true
      return
    }

    self._dismiss()
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(
          alignment: .center,
          spacing: 28
        ) {
          self._content
        }
        .padding(.vertical, 26)
        .containerMargins()
        .frame(maxWidth: .infinity)
      }
      .scrollBounceBehavior(.basedOnSize)
      .scrollDismissesKeyboard(.interactively)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(
            role: .cancel,
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
              Text("Your changes to this \(self._subject) will be lost.")
            }
          )
        }

        ToolbarItem(placement: .confirmationAction) {
          Button(
            role: .confirm,
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
      .navigationSubtitle("Update \(self._subject) details")
      .navigationBarTitleDisplayMode(.inline)
      .interactiveDismissDisabled(self._hasChanges)
    }
    .frame(idealWidth: 440)
    .presentationBackground(Color.base)
    .presentationSizing(
      .form.fitted(
        horizontal: true,
        vertical: false
      )
    )
    .presentationDetents([
      .height(self._height)
    ])
  }
}
