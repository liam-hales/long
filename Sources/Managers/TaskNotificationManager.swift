import Foundation
import SwiftData
import UserNotifications

/// Used to schedule the daily summary notifications
/// for tasks that are overdue or due that day
final class TaskNotificationManager {
  private let _context: ModelContext
  private let _notificationCenter: UNUserNotificationCenter

  /// Initialises the `TaskNotificationManager` with
  /// the model context used to fetch the tasks
  init(context: ModelContext) {
    self._context = context
    self._notificationCenter = .current()
  }

  /// Used to ask the user for permission
  /// to send notifications to their device
  func requestAuth() async -> Void {
    _ = try? await self._notificationCenter.requestAuthorization(options: [.alert, .sound])
  }

  /// Used to schedule summary notifications for the next 14 days
  /// built from the active tasks due on or before each day
  func schedule() -> Void {
    let calendar = Calendar.current

    // Define the descriptor to fetch active tasks that are
    // assigned to a sheet, ordered by ones that are due first
    let descriptor = FetchDescriptor<TaskModel>(
      predicate: #Predicate { task in
        (
          task.sheet != nil &&
          task.completedDate == nil
        )
      },
      sortBy: [SortDescriptor(\.dueDate)]
    )

    let tasks = (try? self._context.fetch(descriptor)) ?? []

    // Remove the previous summaries, including any already
    // delivered, since the tasks may have changed since then
    self._notificationCenter.removeAllPendingNotificationRequests()
    self._notificationCenter.removeAllDeliveredNotifications()

    // Create notifications
    // for the next 14 days
    for offset in 0 ..< 14 {
      guard
        let day = calendar.date(byAdding: .day, value: offset, to: .now),
        let date = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: day)
      else {
        continue
      }

      // Check if the summary time has
      // already passed and if so return
      if (date <= .now) {
        continue
      }

      // Send separate summary notifications
      // for the overdue and due today schedules
      for schedule in [
        TaskModel.Schedule.overdue,
        TaskModel.Schedule.today,
      ] {
        let scheduledTasks = tasks.filter { $0.schedule(at: date) == schedule }

        // Skip the summary notification if
        // there are no tasks for the schedule
        if (scheduledTasks.isEmpty == true) {
          continue
        }

        let content = UNMutableNotificationContent()
        let components = calendar.dateComponents(
          [
            .year,
            .month,
            .day,
            .hour,
            .minute,
          ],
          from: date
        )
        
        let trigger = UNCalendarNotificationTrigger(
          dateMatching: components,
          repeats: false
        )

        content.sound = .default
        content.title = (schedule == .overdue)
          ? "\(scheduledTasks.count) Overdue"
          : "\(scheduledTasks.count) Due Today"

        content.body = scheduledTasks
          .map(\.title)
          .joined(separator: ", ")
        
        // Add the notification to the
        // notification center
        self._notificationCenter.add(
          UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
          )
        )
      }
    }
  }
}
