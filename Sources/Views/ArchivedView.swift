import SwiftData
import SwiftUI

/// Used to display the users
/// archived tasks
struct ArchivedView: View {

  /// Query for the archived tasks stored on device
  /// ordered by ones that were completed first
  @Query(
    filter: #Predicate<TaskModel> { task in
      task.isArchived == true
    },
    sort: \TaskModel.completedDate,
    order: .reverse
  )
  private var _tasks: [TaskModel]

  var body: some View {
    List(self._tasks) { task in
      Text(task.title)
    }
    .navigationTitle("Archived")
  }
}
