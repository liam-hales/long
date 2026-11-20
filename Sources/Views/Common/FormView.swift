import LucideSwift
import SwiftUI

/// Used to display a modal form which allows the
/// user to fill in and save a set of details
struct FormView<Content: View>: View {
  private let _title: String
  private let _subtitle: String
  private let _confirmText: String
  private let _height: CGFloat
  private let _hasChanges: Bool
  private let _isValid: Bool
  private let _onConfirm: () -> Void
  private let _content: Content

  @Environment(\.dismiss)
  private var _dismiss: DismissAction

  @State
  private var _showDiscardConfirmation: Bool = false

  private var _isConfirmDisabled: Bool {
    (
      self._hasChanges == false ||
      self._isValid == false
    )
  }

  /// Initialises the view with the form `content`, its `title`, `subtitle` and
  /// `confirmText`, and the `onConfirm` action to run when the user confirms
  init(
    title: String,
    subtitle: String,
    confirmText: String,
    height: CGFloat,
    hasChanges: Bool,
    isValid: Bool,
    onConfirm: @escaping () -> Void,

    @ViewBuilder
    content: () -> Content
  ) {
    self._title = title
    self._subtitle = subtitle
    self._confirmText = confirmText
    self._height = height
    self._hasChanges = hasChanges
    self._isValid = isValid
    self._onConfirm = onConfirm
    self._content = content()
  }

  /// Used to confirm the form
  /// and dismiss the view
  private func _confirm() -> Void {
    self._onConfirm()
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
        .padding(.top, 26)
        .padding(.bottom, 16)
        .containerMargins()
        .frame(maxWidth: .infinity)
      }
      .toolbarTitleDisplayMode(.inline)
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
              Text("Are you sure? Your changes will be lost.")
            }
          )
        }

        ToolbarItem(placement: .confirmationAction) {
          Button(
            role: .confirm,
            action: self._confirm
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

              Text(self._confirmText)
                .font(.serif(16, .semibold))
            }
            .padding(.horizontal, 6)
            .foregroundStyle(
              (self._isConfirmDisabled == true)
                ? .contentSecondary
                : .white
            )
          }
          .buttonStyle(.glassProminent)
          .disabled(self._isConfirmDisabled)
          .tint(
            (self._isConfirmDisabled == true)
              ? .disabled
              : .accent
          )
        }
      }
      .navigationTitle(self._title)
      .navigationSubtitle(self._subtitle)
      .interactiveDismissDisabled(self._hasChanges)
      .scrollBounceBehavior(.basedOnSize)
      .scrollDismissesKeyboard(.interactively)
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
