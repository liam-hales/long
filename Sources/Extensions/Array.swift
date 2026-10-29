import Foundation

extension Array where Element == TaskModel {

  /// Returns the tasks for a
  /// given task `filter`
  func filtered(by filter: TaskFilter) -> [TaskModel] {
    switch filter {
      case .all:
        return self

      case .overdue:
        return self.filter { task in
          (
            task.isSettled == false &&
            task.schedule == .overdue
          )
        }

      case .today:
        return self.filter { task in
          (
            task.isSettled == false &&
            task.schedule == .today
          )
        }

      case .scheduled:
        return self.filter { task in
          (
            task.isSettled == false &&
            task.schedule == .scheduled
          )
        }

      case .unscheduled:
        return self.filter { task in
          (
            task.isSettled == false &&
            task.schedule == .unscheduled
          )
        }

      case .completed:
        let sort = SortDescriptor(\TaskModel.completedDate, order: .reverse)

        return self
          .filter { task in task.isSettled == true }
          .sorted(using: sort)
    }
  }
}

extension Array where Element == TaskSheetModel {

  /// Returns the task sheets
  /// for a given `sort`
  func sorted(by sort: TaskSheetSort) -> [TaskSheetModel] {
    switch sort {
      case .lastActive:
        return self.sorted { first, second in
          first.activityDate > second.activityDate
        }

      case .name:
        return self.sorted { first, second in
          first.name.localizedStandardCompare(second.name) == .orderedAscending
        }

      case .created:
        return self.sorted { first, second in
          first.createDate > second.createDate
        }
    }
  }
}
