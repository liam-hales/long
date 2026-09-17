import SwiftUI
import LucideSwift

/// Used to render the toolbar displayed above
/// the users tasks in the `TasksView`
struct ToolbarView: ToolbarContent {

  @Binding
  var taskFilter: TaskFilter;

  var body: some ToolbarContent {

    ToolbarItem(placement: .title) {
      Text("Tasks");
    }

    ToolbarItem(placement: .topBarTrailing) {
      Menu(
        content: {
          Picker("Filter", selection: $taskFilter) {
            ForEach(TaskFilter.allCases) { filter in
              Label(
                title: {
                  Text(filter.title);
                },
                icon: {
                  Image(
                    lucide: filter.icon,
                    size: .init(width: 22, height: 22)
                  );
                }
              );
            }
          }
        },
        label: {
          LucideIcon(.listFilter, size: 22);
        }
      )
    }

    ToolbarSpacer(
      .fixed,
      placement: .topBarTrailing
    );

    ToolbarItemGroup(placement: .topBarTrailing) {
      Button(
        action: {},
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
