import SwiftUI
import LucideSwift

/// The main entry point view
/// rendered by the `App`
struct AppView: View {

  var body: some View {
    TabView {
      Tab(
        content: {
          TasksView();
        },
        label: {
          Image(
            lucide: .listCheck,
            size: .init(width: 22, height: 22)
          );
          Text("Tasks");
        },
      );

      Tab(
        content: {
          ArchivedView();
        },
        label: {
          Image(
            lucide: .archive,
            size: .init(width: 22, height: 22)
          );
          Text("Archived");
        },
      );
    }
    .tint(.accent);
  }
}

