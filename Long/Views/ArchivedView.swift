import SwiftUI
import SwiftData

/// Used to display the users
/// archived tasks
struct ArchivedView: View {

  /// Query for the archived tasks stored on device
  /// ordered by ones that were completed first
  @Query(
    filter: #Predicate<TaskItem> {
      $0.isArchived == true
    },
    sort: \TaskItem.completedDate,
    order: .reverse
  )
  private var _tasks: [TaskItem];

  var body: some View {
    NavigationStack {
      List(self._tasks) { task in
        Text(task.title);
      }
      .navigationTitle("Archived");
    }
  }
}
