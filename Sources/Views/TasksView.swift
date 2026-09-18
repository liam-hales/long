import SwiftUI
import SwiftData

/// Used to display the users
// current outstanding tasks
struct TasksView: View {

  @Environment(AppState.self)
  private var _appState: AppState;

  /// Query for the  unarchived tasks stored on
  /// device ordered by ones that are due first
  @Query(
    filter: #Predicate<TaskItem> {
      $0.isArchived == false
    },
    sort: \TaskItem.dueDate,
    order: .reverse
  )
  private var _tasks: [TaskItem];

  var body: some View {

    @Bindable
    var appState = _appState;

    NavigationStack {
      List(self._tasks) { task in
        Text(task.title);
      }
      .toolbar {
        ToolbarView()
      }
      .sheet(
        isPresented: $appState.isCreatingTask,
        content: {
          CreateTaskView();
        }
      )
      .scrollContentBackground(.hidden)
      .background(Color.base);
    }
  }
}
