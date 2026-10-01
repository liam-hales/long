import LucideSwift
import SwiftUI

/// Used to render the toolbar displayed above
/// the users tasks in the `TaskSheetView`
struct TaskSheetToolbar: ToolbarContent {

  @Environment(AppState.self)
  private var _appState: AppState

  var body: some ToolbarContent {

    @Bindable
    var appState = _appState

    ToolbarItem(placement: .topBarTrailing) {
      Menu(
        content: {
          Picker("Focus", selection: $appState.taskFocus) {
            ForEach(TaskFocus.allCases) { focus in
              Label(
                title: {
                  Text(focus.title)
                },
                icon: {
                  Image(
                    lucide: focus.icon,
                    size: .init(width: 22, height: 22)
                  )
                }
              )
            }
          }
          .tint(.contentPrimary)
          .pickerStyle(.inline)
        },
        label: {
          let isActive = (self._appState.taskFocus != .all)

          HStack(
            alignment: .center,
            spacing: 12
          ) {
            VStack(
              alignment: .leading,
              spacing: 2
            ) {
              Text("Focus on")
                .foregroundStyle(Color.contentSecondary)
                .font(.serif(11, .regular))

              Text(appState.taskFocus.title)
                .font(.serif(13, .bold))
            }

            ZStack(alignment: .center) {
              if (isActive == true) {
                Circle()
                  .fill(Color.accent)
              }

              LucideIcon(
                self._appState.taskFocus.icon,
                size: 22,
                color: (isActive == true)
                  ? .white
                  : .contentPrimary
              )
            }
            .frame(
              width: 34,
              height: 34
            )
          }
          .padding(.leading, 8)
          .padding(.trailing, -4)
        }
      )
    }

    ToolbarSpacer(
      .fixed,
      placement: .topBarTrailing
    )

    ToolbarItem(placement: .topBarTrailing) {
      Button(
        action: {
          self._appState.modalSelection = .editTaskSheet
        },
        label: {
          LucideIcon(.pencil, size: 22)
        }
      )
    }
  }
}
