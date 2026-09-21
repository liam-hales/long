import SwiftUI
import LucideSwift

/// Used to display the task input the user can use
// to create tasks in either manual or auto mode
struct TaskInputView: View {

  @Environment(AppState.self)
  private var _appState: AppState;

  @State
  private var _mode: TaskInputMode = .manual;

  @State
  private var _manualInputValue: String = "";

  @State
  private var _autoInputValue: String = "";

  /// Used  to trigger the task
  /// creation in manual mode
  private func _onManual() -> Void {
    self._appState.createTask(title: self._manualInputValue);
    self._manualInputValue = "";
  }

  var body: some View {
    VStack(
      alignment: .center,
      spacing: 16
    ) {
      HStack(
        alignment: .center,
        spacing: 4
      ) {
        Button(
          action: {
            self._mode = .manual;
          },
          label: {
            Text("Manual")
              .frame(maxWidth: .infinity)
              .padding(.vertical, 2)
              .font(.serif(16, .bold))
              .foregroundStyle(
                (self._mode == .manual)
                  ? Color.contentPrimary
                  : Color.contentSecondary
              );
          }
        )
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 8))
        .tint(
          (self._mode == .manual)
            ? .white
            : .clear
        );

        Button(
          action: {
            self._mode = .auto;
          },
          label: {
            Text("Auto")
              .frame(maxWidth: .infinity)
              .padding(.vertical, 2)
              .font(.serif(16, .bold))
              .foregroundStyle(
                (self._mode == .auto)
                  ? Color.contentPrimary
                  : Color.contentSecondary
              );
          }
        )
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 8))
        .tint(
          (self._mode == .auto)
            ? .white
            : .clear
        );
      }
      .padding(.all, 4)
      .background(Color.surfaceLow)
      .cornerRadius(10)

      if (self._mode == .manual) {
        HStack(
          alignment: .center,
          spacing: 4
        ) {
          TextField("What do you need to get done?", text: self.$_manualInputValue)
            .submitLabel(.done)
            .onSubmit {
              self._onManual();
            }

          Button(
            action: {
              self._onManual();
            },
            label: {
              LucideIcon(.arrowUp, size: 22)
                .foregroundStyle(.white)
            }
          )
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.roundedRectangle(radius: 10))
          .tint(.accent);
        }
        .padding(.leading, 4)
      }
    }
    .padding(.all, 10)
    .background(Color.surfaceHigh)
    .cornerRadius(14)
    .overlay(
      RoundedRectangle(cornerRadius: 14)
        .stroke(Color.outline, lineWidth: 1)
    );
  }
}
