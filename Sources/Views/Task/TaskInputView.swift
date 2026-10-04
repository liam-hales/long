import LucideSwift
import SwiftUI

/// Used to display the task input the
/// user can use to create tasks
struct TaskInputView: View {

  @Environment(AppState.self)
  private var _appState: AppState

  @Environment(\.displayScale)
  private var _displayScale: CGFloat

  @State
  private var _isCapturing: Bool = false

  @State
  private var _captureError: TaskCaptureError?

  private var _isDisabled: Bool {
    (
      self._isCapturing == true ||
      self._appState.taskInput
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .isEmpty
    )
  }

  /// Used to capture tasks from the task input
  /// and show an error if it fails
  private func _capture() -> Void {
    self._isCapturing = true

    Task {
      do {

        // Attempt to capture the tasks
        // from the user input
        try await self._appState.captureTasks()
      }
      catch {
        print("Failed to capture tasks: \(error)")

        // Use the capture error if there is one, otherwise
        // fall back to a generic failed error
        self._captureError = (error as? TaskCaptureError) ?? .failed
      }

      self._isCapturing = false
    }
  }

  var body: some View {

    @Bindable
    var appState = _appState

    VStack(
      alignment: .center,
      spacing: 0
    ) {
      Rectangle()
        .fill(Color.outline)
        .frame(height: 2 / self._displayScale)
        .ignoresSafeArea(edges: .horizontal)
        .allowsHitTesting(false)

      VStack(
        alignment: .center,
        spacing: 12
      ) {
        HStack(
          alignment: .bottom,
          spacing: 8
        ) {
          TextField(
            "Add tasks",
            text: $appState.taskInput,
            prompt: Text("What do you need to get done?")
              .foregroundStyle(Color.contentSecondary),
            axis: .vertical
          )
          .padding(.leading, 8)
          .padding(.vertical, 8)
          .lineLimit(8)
          .submitLabel(.return)
          .disabled(self._isCapturing)
          .onChange(of: self._appState.taskInput) { oldValue, newValue in

            // Check if the user has just started typing
            // and if so start the capture session
            if (
              oldValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true &&
              newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
            ) {
              self._appState.startCaptureSession()
            }
          }

          Button(
            action: self._capture
          ) {
            if (self._isCapturing == true) {
              LoaderView(size: 22)
                .frame(width: 14, height: 22)
                .foregroundStyle(Color.contentSecondary)
            }

            if (self._isCapturing == false) {
              LucideIcon(.arrowUp, size: 22)
                .frame(width: 14, height: 22)
                .foregroundStyle(
                  (self._isDisabled == true)
                    ? .contentSecondary
                    : .white
                )
            }
          }
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.roundedRectangle(radius: 10))
          .disabled(self._isDisabled)
          .tint(
            (self._isDisabled == true)
              ? .disabled
              : .accent
          )
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(
          RoundedRectangle(cornerRadius: 14)
            .fill(Color.surfaceHigh)
            .strokeBorder(Color.outline, lineWidth: 1)
        )

        Text("Capturing tasks uses Apple Intelligence which can make mistakes. Review tasks before they are added.")
          .font(.serif(14, .regular))
          .lineHeight(.multiple(factor: 1.4))
          .foregroundStyle(Color.contentSecondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 6)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 16)
    }
    .background(Color.base)
    .alert(
      self._captureError?.title ?? "",
      isPresented: Binding(
        get: {
          self._captureError != nil
        },
        set: { _ in
          self._captureError = nil
        }
      ),
      presenting: self._captureError,
      actions: { _ in
        Button("OK", role: .cancel) {
          self._captureError = nil
        }
      },
      message: { error in
        Text(error.message)
      }
    )
  }
}
