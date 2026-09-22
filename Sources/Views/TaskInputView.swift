import SwiftUI
import LucideSwift

/// Used to display the task input the user can use to
/// create tasks in either add or capture mode
struct TaskInputView: View {

  @Environment(AppState.self)
  private var _appState: AppState;

  @State
  private var _mode: TaskInputMode = .add;

  @State
  private var _addInputValue: String = "";

  @State
  private var _captureInputValue: String = "";

  /// Used to trigger the task action based
  /// on the current task input mode
  private func _onSubmit() -> Void {
    switch self._mode {
      
      // For add mode, create the
      // task and clear the input state
      case .add:
        self._appState.createTask(title: self._addInputValue);
        self._addInputValue = "";
      
        break;
      
      // For capture mode, capture the tasks
      // and clear the input state
      case .capture:
        self._captureInputValue = "";
      
        break;
    }
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
        ForEach(TaskInputMode.allCases) { mode in
          let isSelected: Bool = (mode == self._mode);
          
          Button(
            action: {
              self._mode = mode;
            },
            label: {
              HStack(
                alignment: .center,
                spacing: 6
              ) {
                LucideIcon(mode.icon, size: 16)
                
                Text(mode.title)
                  .font(.serif(16, .bold))
                  .padding(.top, 2);
              }
              .frame(maxWidth: .infinity)
              .padding(.vertical, 2)
              .foregroundStyle(
                (isSelected == true)
                  ? Color.contentPrimary
                  : Color.contentSecondary
              );
            }
          )
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.roundedRectangle(radius: 8))
          .tint(
            (self._mode == mode)
              ? .white
              : .clear
          );
        }
      }
      .padding(.all, 5)
      .background(Color.surfaceLow)
      .cornerRadius(10)

      if (self._mode == .add) {
        HStack(
          alignment: .center,
          spacing: 4
        ) {
          TextField("What do you need to get done?", text: self.$_addInputValue)
            .padding(.leading, 8)
            .lineLimit(1)
            .submitLabel(.done)
            .onSubmit {
              self._onSubmit();
            }

          Button(
            action: {
              self._onSubmit();
            },
            label: {
              LucideIcon(.arrowUp, size: 22)
                .frame(width: 14, height: 22)
                .foregroundStyle(.white)
            }
          )
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.roundedRectangle(radius: 10))
          .tint(.accent);
        }
      }
      
      if (self._mode == .capture) {
        VStack(
          alignment: .center,
          spacing: 24
        ) {
          TextField("Empty your thoughts here...", text: self.$_captureInputValue)
            .padding(.horizontal, 8)
            .lineLimit(6)
            .submitLabel(.return)
          
          HStack(
            alignment: .center,
            spacing: 10
          ) {
            Text("You will review captured tasks before they are created.")
              .padding(.leading, 8)
              .font(.mono(12))
              .foregroundStyle(Color.contentSecondary);
            
            Spacer();
            
            Button(
              action: {
                self._onSubmit();
              },
              label: {
                LucideIcon(.arrowUp, size: 22)
                  .frame(width: 14, height: 22)
                  .foregroundStyle(.white)
              }
            )
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .tint(.accent);
          }
        }
        .padding(.top, 8);
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
