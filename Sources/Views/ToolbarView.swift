import SwiftUI
import LucideSwift

/// Used to render the toolbar displayed above
/// the users tasks in the `TasksView`
struct ToolbarView: ToolbarContent {

  @Environment(AppState.self)
  private var _appState: AppState;

  var body: some ToolbarContent {

    @Bindable
    var appState = _appState;

    ToolbarItem(placement: .topBarTrailing) {
      Menu(
        content: {
          Picker("Filter", selection: $appState.taskFilter) {
            ForEach(TaskFilter.allCases) { filter in
              Label(
                title: {
                  Text(filter.title)
                },
                icon: {
                  Image(
                    lucide: filter.icon,
                    size: .init(width: 22, height: 22)
                  )
                }
              )
            }
          }
          .tint(.contentPrimary)
          .pickerStyle(.inline);
        },
        label: {
          HStack(
            alignment: .center,
            spacing: 14
          ) {
            VStack(
              alignment: .leading,
              spacing: 2
            ) {
              Text("Filter by")
                .foregroundStyle(Color.contentSecondary)
                .font(.serif(11, .regular))

              Text(appState.taskFilter.title)
                .font(.serif(13, .bold))
            }

            LucideIcon(
              self._appState.taskFilter.icon,
              size: 22,
              color: .contentPrimary
            );
          }
          .padding(.horizontal, 8);
        }
      )
    }

    ToolbarSpacer(
      .fixed,
      placement: .topBarTrailing
    );

    ToolbarItem(placement: .topBarTrailing) {
      Button(
        action: {},
        label: {
          LucideIcon(.settings, size: 22);
        }
      )
    }
  }
}
