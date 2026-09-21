import SwiftUI
import SwiftData
import LucideSwift

/// Used to display the users
/// current outstanding tasks
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
  
  private var _overdueTasks: [TaskItem] {
    return self._tasks.filter { task in task.status == .overdue };
  }

  private var _todayTasks: [TaskItem] {
    return self._tasks.filter { task in task.status == .today };
  }
  
  private var _scheduledTasks: [TaskItem] {
    return self._tasks.filter { task in task.status == .scheduled };
  }
  
  private var _unscheduledTasks: [TaskItem] {
    return self._tasks.filter { task in task.status == .unscheduled };
  }

  var body: some View {

    @Bindable
    var appState = _appState;

    NavigationStack {
      List {
        TaskInputView()
          .padding(.vertical, 10)
          .listRowBackground(Color.clear)
          .listRowSeparator(.hidden)
          .listRowInsets(.horizontal, 0);
        
        if (self._tasks.isEmpty == true) {
          VStack(
            alignment: .center,
            spacing: 6
          ) {
            Text("No tasks.")
              .font(.serif(22, .bold));
            Text("You currently have no tasks to complete, try creating one below.")
              .foregroundStyle(Color.contentSecondary)
              .font(.serif(14, .regular))
              .frame(maxWidth: 260)
              .multilineTextAlignment(.center);
          }
          .frame(maxWidth: .infinity)
          .padding(.vertical, 20)
          .listRowBackground(Color.clear)
          .listRowSeparator(.hidden)
          .listRowInsets(.horizontal, 0);
        }
        
        if (self._todayTasks.isEmpty == false) {
          Section(
            content: {
              ForEach(self._todayTasks) { task in
                Text(task.title);
              }
            },
            header: {
              Text("Today")
                .foregroundStyle(Color.contentSecondary)
                .font(.mono(16));
            }
          )
          .listRowInsets(.horizontal, 0);
        }
        
        if (self._scheduledTasks.isEmpty == false) {
          Section(
            content: {
              ForEach(self._scheduledTasks) { task in
                Text(task.title);
              }
            },
            header: {
              Text("Scheduled")
                .foregroundStyle(Color.contentSecondary)
                .font(.mono(16));
            }
          )
          .listRowInsets(.horizontal, 0);
        }
        
        if (self._unscheduledTasks.isEmpty == false) {
          Section(
            content: {
              ForEach(self._unscheduledTasks) { task in
                Text(task.title);
              }
            }
          )
          .listRowInsets(.horizontal, 0);
        }
      }
      .navigationTitle("Tasks")
      .toolbar {
        ToolbarView();
      }
      .scrollContentBackground(.hidden)
      .background(Color.base);
    }
  }
}
