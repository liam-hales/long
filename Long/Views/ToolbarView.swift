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

    ToolbarItem(placement: .title) {
      Text("Tasks");
    }

    ToolbarItem(placement: .topBarTrailing) {
      Menu(
        content: {
          Picker(
            "Filter",
            selection: $appState.taskFilter,
            content: {
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
          )
          .pickerStyle(.inline);
        },
        label: {
          HStack(
            alignment: .center,
            spacing: 14
          ) {
            VStack(
              alignment: .leading,
              spacing: 0
            ) {
              Text("Filter by")
                .font(.caption2);
              Text(appState.taskFilter.title)
                .font(.caption);
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

    ToolbarItemGroup(placement: .topBarTrailing) {
      Button(
        action: {
          self._appState.status = .creatingTask;
        },
        label: {
          LucideIcon(.plus, size: 22);
        }
      )

      Button(
        action: {},
        label: {
          LucideIcon(.sparkles, size: 22);
        }
      )
    }
  }
}
